#!/bin/bash
# Final Exam

source /multiplatform/Linux/functions.sh

# Gather Student Work

clear
is_super_user
student_info 2420_Final_Exam
echo -n "Enter your Windows internal IP: "
read winip
echo -n "Enter your Ubuntu internal IP: "
read ubuntuip

# bind

echo -e "bind checks: Ubuntu" | tee -a $outfile
dig @localhost +noall +answer www.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer ubuntu.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer linux.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer mail.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer cet2420-final.org MX | tee -a $outfile
dig @localhost +noall +answer windows.cet2420-final.org | tee -a $outfile
dig @localhost +noall +answer s2016.cet2420-final.org | tee -a $outfile
echo -e "bind checks: Windows" | tee -a $outfile
echo -e "Primary:" | tee -a $outfile
dig @$winip +noall +answer final.cet2420-win.org | tee -a $outfile
dig @$winip +noall +answer tux.cet2420-win.org | tee -a $outfile
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
check_existence 0 /var/www/cet2420-final.org/index.html f
check_existence 0 /var/www/cet2420-final.org/error.html f
blank_line
http --verify=no https://www.cet2420-final.org | tee -a $outfile
http --verify=no https://www.cet2420-final.org/generaterror.html tee -a $outfile
blank_line
echo -e "windows checks" | tee -a $outfile
http --verify=no https://windows.cet2420-final.org | tee -a $outfile
http --verify=no https://windows.cet2420-final.org/generaterror.html tee -a $outfile
blank_line

echo -e "dhcp check"
/usr/bin/dhtest -i ens4 m 01:01:01:22:33:FF -g 192.168.254.2 -S $ubuntuip | tee -a $outfile
blank_line

echo -e "nfs check"
exportfs -v | tee -a $outfile

echo -e "CONFIG FILES" | tee -a $outfile
echo -e "/etc/bind/named.conf.local" | tee -a $outfile
cat /etc/bind/named.conf.local | tee -a $outfile
blank_line
echo -e "/var/cache/bind/cet2420-final.org" | tee -a $outfile
cat /var/cache/bind/cet2420-final.org | tee -a $outfile
blank_line
echo -e "/etc/apache2/sites-enabled/cet2420-final.org.conf" | tee -a $outfile
cat /etc/apache2/sites-enabled/cet2420-final.org.conf | tee -a $outfile
blank_line
echo -e "/etc/dhcp/dhcpd.conf" | tee -a $outfile
cat /etc/dhcp/dhcpd.conf | tee -a $outfile
blank_line
echo -e "/etc/exports"
cat /etc/exports | tee -a $outfile
blank_line

mail_out 2420 Final Exam
