#!/bin/bash

#
# Functions
#

# blank line

blank_line(){
echo -e "\n" | tee -a $outfile
return 0
}

# Check if superuser

is_super_user(){
	if [ $EUID -ne 0 ]
then
        echo "Insufficient permissions. Run this script as root, or with sudo."
        exit 1
else
	return 0
fi
}

# Gather Student Information and Create Information File

student_info(){
echo -e "CET2420 $1 $2 Submission"
echo -n "Enter your first name: "
read fname
echo -n "Enter your last name: "
read lname
echo -n "Enter your Student number: "
read snumber
echo -n "Enter your email address: "
read mailaddy
fname=`echo $fname | sed 's/ /_/g'`
lname=`echo $lname | sed 's/ /_/g'`
filename=$snumber-$1_$2_${fname:0:1}_$lname.txt
tarfile=$snumber-$1_$2_${fname:0:1}_$lname.tar.gz
outfile=/tmp/$filename

echo -e "Work will be saved in $outfile \n"
echo $HOSTNAME > $outfile
echo -e "CET2420 $1 $2 - ($snumber) $fname $lname \n" | tee -a $outfile
return 0
}

student_info_test(){
echo -e "CET2420 $1 $2 Submission"
echo -n "Enter your first name: "
read fname
echo -n "Enter your last name: "
read lname
echo -n "Enter your Student number: "
read snumber
fname=`echo $fname | sed 's/ /_/g'`
lname=`echo $lname | sed 's/ /_/g'`
filename=$snumber-$1_$2_${fname:0:1}_$lname.txt
tarfile=$snumber-$1_$2_${fname:0:1}_$lname.tar.gz
outfile=/tmp/$filename

echo -e "Work will be saved in $outfile \n"
echo $HOSTNAME > $outfile
echo -e "CET2420 $1 $2 - ($snumber) $fname $lname \n" | tee -a $outfile
return 0
}

# Is Package Installed?
# parameters question , packagename

package_check(){
if ! dpkg --list | grep -qw $2; then
	echo -e "!! Error !! Question $1: Package $2 not installed - try again." | tee -a $outfile
else
	echo -e "Question $1: Package $2 installed - good." | tee -a $outfile
fi
return 0
}

# Mail Work

mail_out(){

content=`base64 -w0 $outfile`
attachment="$1_$2-$lname-$fname.txt"

read -p "Mail your work to your instructor? (y to send mail or CTRL-C to exit) "
[ "$REPLY" != "y" ] || curl --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $SENDGRID_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "dave@davecushing.ca"}],"cc": [{"email":"'"$mailaddy"'"}]}],"from": {"email": "dave@davecushing.ca"},"subject": "'"$fname $lname: $1 $2"'","content": [{"type": "text/plain", "value": "Sent as attachment:"}] , "attachments": [{"content": "'"$content"'", "type": "text/plain", "filename": "'"$attachment"'"}]}'

exit 0
}
mail_out_test(){

content=`base64 -w0 $outfile`
attachment="$1_$2-$lname-$fname.txt"

read -p "Mail your work to your instructor? (y to send mail or CTRL-C to exit) "
[ "$REPLY" != "y" ] || curl --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $SENDGRID_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "dave@davecushing.ca"}]}],"from": {"email": "dave@davecushing.ca"},"subject": "'"$1 $2: $fname $lname"'","content": [{"type": "text/plain", "value": "Sent as attachment:"}] , "attachments": [{"content": "'"$content"'", "type": "text/plain", "filename": "'"$attachment"'"}]}'

exit 0
}
# Check Line Count
# parameters question, filename, expected lines

check_line_count(){
if [ -f $2 ];
then
	if [[ "`wc -l < $2`" == $3 ]]; then
		echo -e "Question $1: $2 - correct number of lines $3" | tee -a $outfile
	else
		echo -e "!! ERROR !! Question $1: $2 - incorrect number of lines - expected $3 lines - actual lines: `wc -l < $2`" | tee -a $outfile
	fi
	return 0
else
        echo -e "!! ERROR !! Question $1: $2 - doesn't exist, can't determine line count." | tee -a $outfile
	return 0
fi
}

# Check Permissions
# parameters question, filename, permissions -rwxrwxrwx

check_permissions(){
if [ `stat -c %A $2` == $3 ]; then
        echo -e "Question $1: $2 - correct permissions" | tee -a $outfile
	return 0
else
        echo -e "!! ERROR !! Question $1: $2 - incorrect permissions, should be $3." | tee -a $outfile
	return 0
fi
}

# Check Owner
# Parameters question, filename, owner

check_owner(){
if [ `stat -c %U $2` == $3 ]; then
        echo -e "Question $1: $2 - correct owner" | tee -a $outfile
	return 0
else
        echo -e "!! ERROR !! Question $1: $2 - incorrect owner, should be $3." | tee -a $outfile
	return 0
fi
}

# Check Group
# Parameters question, filename, group

check_group(){
if [ `stat -c %G $2` == $3 ]; then
        echo -e "Question $1: $2 - correct group" | tee -a $outfile
	return 0
else
        echo -e "!! ERROR !! Question $1: $2 - incorrect group, should be $3." | tee -a $outfile
	return 0
fi
}

# Check if file or directory exists
# Parameters question, path, f, b (block device), h (symlink) or d

check_existence(){
if [ -$3 $2 ];
then
        echo -e "Question $1: $2 - exists" | tee -a $outfile
	return 0
else
        echo -e "!! ERROR !! Question $1: $2 - doesn't exist, try again." | tee -a $outfile
	return 0
fi
}

# Check if file or directory DOES NOT exist
# Parameters question, path, f, b (block device), h (symlink) or d

check_no_existence(){
if [ -$3 $2 ];
then
        echo -e "!! ERROR !! Question $1: $2 - exists, try again." | tee -a $outfile
	return 0
else
        echo -e "Question $1: $2 - does not exist." | tee -a $outfile
	return 0
fi
}

# Check if user or group exists
# Parameters question, username/groupname, passwd group

entity_exists(){
getent $3 $2 > /dev/null
if [ $? -eq 0 ]; then
    echo -e "Question $1: $2 exists" | tee -a $outfile
else
    echo -e "!! ERROR !! Question $1: $2 DOES NOT exist - please create" | tee -a $outfile
fi
return 0
}

# Check various user parameters
# Check1 question, user_in_group, username, group
# Check2 question, account_expiry, username, expire_date
# Check3 question, comment, username, comment
user_param(){
case $2 in
user_in_group)
	if grep -q -E "^$4:.*[:,]$3(,.*|\b)" /etc/group; then
		echo -e "Question $1: $3 is in group $4" | tee -a $outfile
	else
		echo -e "!! ERROR !! Question $1: $3 is NOT in group $4 - please correct" | tee -a $outfile
fi
;;
account_expiry)
	userexpdate=`chage -l $3 | grep 'Account expires' | cut -d: -f2`
	noexpire="never"
	if [[ $userexpdate == " never" ]]; then
        	echo -e "** ERROR ** Question $1: $3: INCORRECT account expiry date." | tee -a $outfile
	else
		convexpdate=`date -d "$userexpdate" +%s`
		conv2expdate=`date -d "$4" +%s`
		if [ $convexpdate == $conv2expdate ]; then
				echo -e "Question $1: $3: Correct account expiry date $4" | tee -a $outfile
		else
				echo -e "!! ERROR !! Question $1: $3: INCORRECT account expiry date. Should be $4" | tee -a $outfile
		fi
	fi
;;
comment)
	# Check comment field for correct string
	# Parameters question, comment, username, comment string

	if [ "`grep $3 /etc/passwd | cut -d: -f5`" == "$4" ]; then
	        echo -e "Question $1: $3: Correct comment $4" | tee -a $outfile
	else
        	echo -e "!! ERROR !! Question $1: $3: INCORRECT comment field - should be $4" | tee -a $outfile
	fi
;;
shell)
	# Check shell field for correct string
	# Parameters question, shell, username, shell string

	if [ "`grep $3 /etc/passwd | cut -d: -f7`" == "$4" ]; then
	        echo -e "Question $1: $3: Correct shell $4" | tee -a $outfile
	else
        	echo -e "!! ERROR !! Question $1: $3: INCORRECT shell - should be $4" | tee -a $outfile
	fi
;;
pass_exists)
	# Check if password exists for a user
	# Parameters question, pass_exists, username
	if getent shadow | grep $3 | cut -d: -f1-2 | grep ':$6' > /dev/null; then
		echo -e "Question $1: $3's password is set." | tee -a $outfile
	else
		echo -e "!! ERROR !! Question $1: $3's password is NOT set." | tee -a $outfile
	fi
;;
esac
return 0
}


# Check password age/warn/min-days-between-change 
# Parameters question, username, age-in-days, field (5=age,6=warn,4=min), check text

check_passdates(){
if [ `grep $2 /etc/shadow | cut -d: -f$4` -eq $3 ]; then
        echo -e "Question $1: $2: Correct $5 $3" | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $2: INCORRECT $5 - should be $3" | tee -a $outfile
fi
}

# Check various things about a mounted partition
# Check 1 question, part_size, /dev/sdxx, size_in_bytes
# Check 2 question, is_mounted, /dev/sdxx
# Check 3 question, mount_point, /mount/point, /dev/sdxx
# Check 4 question, in_fstab, /dev/sdxx
# Check 5 question, fs_type, /dev/sdxx, type
check_part(){
case $2 in
part_size)
	if [ `sfdisk -s $3` == $4 ]; then
        echo -e "Question $1: $3: Correct size $4" | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $3: INCORRECT size - should be $4" | tee -a $outfile
fi
;;
is_mounted)
	if grep -qs "$3" /proc/mounts; then
        echo -e "Question $1: $3: is mounted" | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $3: is NOT mounted - please mount" | tee -a $outfile
fi
;;
mount_point)
	if grep "$4" /proc/mounts | grep -qs "$3"; then
        echo -e "Question $1: $4 is mounted at $3 " | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $4: is NOT mounted at $3 - please mount" | tee -a $outfile
fi
;;
in_fstab)
	if grep -qs "$3" /etc/fstab; then
        echo -e "Question $1: $3 is in /etc/fstab " | tee -a $outfile
	grep "$3" /etc/fstab | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $3: is NOT in /etc/fstab - please edit" | tee -a $outfile
fi
;;
fs_type)
	if grep "$3" /proc/mounts | grep -qs "$4"; then
        echo -e "Question $1: $3 is type $4 " | tee -a $outfile
else
        echo -e "!! Error !! Question $1: $3: is NOT type $4 - please fix" | tee -a $outfile
fi
;;
esac
return 0
}
