#!/bin/bash
# Final Exam

source /multiplatform/Linux/functions.sh
gzip -d /multiplatform/Linux/sendgrid.sh.gz 2>&1>/dev/null
chmod 755 /multiplatform/Linux/sendgrid.sh
source /multiplatform/Linux/sendgrid.sh
sendgridapi
gzip /multiplatform/Linux/sendgrid.sh

# Gather Student Work

clear
is_super_user
student_info_test 2420 Final
echo -n " Enter your Ubuntu internal IP: "
read ubuntuip
echo -n "Enter your Windows internal IP: "
read winip

# bind

echo -e "DNS checks: Ubuntu" | tee -a $outfile
echo -e "Primary:" | tee -a $outfile
dig @localhost +noall +answer www.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer ubuntu.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer linux.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer mail.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer cet2420-final.org MX | tee -a $outfile
dig @localhost +noall +answer windows.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer s2016.cet2420-final.org | tee -a $outfile
blank_line
echo -e "DNS checks: Windows" | tee -a $outfile
echo -e "Primary:" | tee -a $outfile
dig @$winip +noall +answer final.cet2420-win.org | tee -a $outfile
dig @$winip +noall +answer tux.cet2420-win.org | tee -a $outfile
blank_line
echo -e "Secondary:" | tee -a $outfile
dig @$winip +noall +answer www.cet2420-final.org | tee -a $outfile
dig @$winip +noall +answer ubuntu.cet2420-final.org | tee -a $outfile
dig @$winip +noall +answer linux.cet2420-final.org | tee -a $outfile
dig @$winip +noall +answer mail.cet2420-final.org | tee -a $outfile
dig @$winip +noall +answer cet2420-final.org MX | tee -a $outfile
dig @$winip +noall +answer windows.cet2420-final.org | tee -a $outfile
dig @$winip +noall +answer s2016.cet2420-final.org | tee -a $outfile
blank_line

echo -e "apache checks" | tee -a $outfile
echo -e "https://www.cet2420-final.org Check:" | tee -a $outfile
http --verify=no https://www.cet2420-final.org | tee -a $outfile
blank_line
echo -e "https://www.cet2420-final.org Error Page Check:" | tee -a $outfile
http --verify=no https://www.cet2420-final.org/generaterror.html | tee -a $outfile
blank_line
echo -e "windows checks" | tee -a $outfile
echo -e "https://windows.cet2420-final.org Check:" | tee -a $outfile
http --verify=no https://windows.cet2420-final.org | tee -a $outfile
echo -e "https://windows.cet2420-final.org Error Page Check:" | tee -a $outfile
http --verify=no https://windows.cet2420-final.org/generaterror.html | tee -a $outfile
blank_line

echo -e "dhcp check" | tee -a $outfile
/usr/bin/dhtest -i ens4 -m 01:01:01:22:33:FF -g 192.168.254.2 -S $ubuntuip | tee -a $outfile
blank_line

echo -e "nfs check" | tee -a $outfile
exportfs -v | tee -a $outfile
blank_line

echo -e "CONFIG FILES" >> $outfile
echo -e "/etc/bind/named.conf.local" >> $outfile
cat /etc/bind/named.conf.local >> $outfile
echo -e " " >> $outfile
echo -e "/var/cache/bind/cet2420-final.org" >> $outfile
cat /var/cache/bind/cet2420-final.org >> $outfile
echo -e " " >> $outfile
echo -e "/etc/apache2/sites-enabled/cet2420-final.org.conf" >> $outfile
cat /etc/apache2/sites-enabled/cet2420-final.org.conf >> $outfile
echo -e " " >> $outfile
echo -e "/etc/dhcp/dhcpd.conf" >> $outfile
cat /etc/dhcp/dhcpd.conf >> $outfile
echo -e " " >> $outfile
echo -e "/etc/exports" >> $outfile
cat /etc/exports >> $outfile
echo -e " " >> $outfile

mail_out_midterm 2420 Final
