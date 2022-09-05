#!/bin/bash

source /scripts/functions.sh
clear
is_super_user
alldone="n"
while [[ $alldone != [Yy] ]]
do
	clear
	echo -n "Enter INSTRUCTOR email address: "
	read inmailaddy
	echo -n "     Enter your student number: "
	read snumber
	echo -n "         Enter your first name: "
	read fname
	echo -n "          Enter your last name: "
	read lname
	echo -n "      Enter YOUR email address: "
	read mailaddy
	echo -e " "
	echo -e "Instructor: $inmailaddy"
	echo -e " "
	echo -e "  Your Name: $fname $lname"
	echo -e " Your Email: $mailaddy"
	echo -e " "
	echo -n "Correct? [y|n]? "
	read alldone
done

fname=`echo $fname | sed 's/ /_/g'`
lname=`echo $lname | sed 's/ /_/g'`
hname=`echo $lname-$fname`

mkdir -p /home/linuxuser/.info
chown linuxuser:linuxuser /home/linuxuser/.info

cat << EOF > ~/.info/.info
Name:$fname $lname
FName:$fname
LName:$lname
Email:$mailaddy
Student:$snumber
Instructor:$inmailaddy
EOF

cp /etc/rport/rport.conf.init /etc/rport/rport.conf
sed -i -e "s/my_win_vm_1/$hname/g" /etc/rport/rport.conf
rport --service install --service-user rport --config /etc/rport/rport.conf
systemctl enable rport &> /dev/null
systemctl stop rport &> /dev/null
systemctl start rport &> /dev/null

curl --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $SENDGRID_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "'"$mailaddy"'"}],"cc": [{"email":"'"$inmailaddy"'"}]}],"from": {"email": "'"$inmailaddy"'"},"subject": "'"Email from $fname $lname"'","content": [{"type": "text/plain", "value": "This is a test."}]}'
