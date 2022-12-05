#!/bin/bash

# 2420 Final Exam Prep Script

source /multiplatform/Linux/functions.sh

clear
is_super_user

student_info Final Prep
clear
echo -e "Starting Setup.."
package_check - httpie
package_check - nfs-kernel
package_check - nfs-common
package_check - cifs-utils
package_check - isc-dhcp-server
blank_line

echo -e "..Cleaning bind..." | tee -a $outfile
systemctl stop bind9 &> /dev/null
cp -f /etc/bind/named.conf.local /etc/bind/named.conf.local.final
cp -f /multiplatform/Linux/final/named.conf.local /etc/bind/
chown root:bind /etc/bind/named.conf.local
chmod 644 /etc/bind/named.conf.local
cp -f /multiplatform/Linux/final/cet2420-final.org /var/cache/bind/
check_existence - /var/cache/bind/cet2420-final.org f
echo -e "..bind9 is stopped... remember to start in exam..."
blank_line

echo -e "..Cleaning Apache Sites..." | tee -a $outfile
systemctl stop apache2
mkdir -p /etc/apache2/sites-enabled/final_backup &> /dev/null
mkdir -p /var/www/cet2420-final.org &> /dev/null
mv /etc/apache2/sites-enabled/[!0]*.conf /etc/apache2/sites-enabled/final_backup/ &> /dev/null
cp -f /multiplatform/Linux/final/cet2420-final.org.conf /etc/apache2/sites-enabled/
cp -f /multiplatform/Linux/final/apacheindex.html /var/www/cet2420-final.org/index.html
cp -f /multiplatform/Linux/final/apacherror.html /var/www/cet2420-final.org/error.htm
cp -f /multiplatform/Linux/final/cet2420-final.org.key /etc/ssl/cet2420-final.org.key
cp -f /multiplatform/Linux/final/cet2420-final.org.pem /etc/ssl/cet2420-final.org.pem
chmod 644 /etc/ssl/cet2420-final.org.key
chmod 644 /etc/ssl/cet2420-final.org.pem
chmod 666 /etc/apache2/sites-enabled/cet2420-final.org.conf
chmod 666 /var/www/cet2420-final.org/index.html
chmod 666 /var/www/cet2420-final.org/error.htm
check_existence - /etc/ssl/cet2420-final.org.key f
check_existence - /etc/ssl/cet2420-final.org.pem f
check_existence - /etc/apache2/sites-enabled/cet2420-final.org.conf f
check_existence - /var/www/cet2420-final.org/index.html f
check_existence - /var/www/cet2420-final.org/error.htm f
a2enmod ssl &> /dev/null
systemctl start apache2
blank_line
apache2ctl -t -D DUMP_VHOSTS | grep "final" | tee -a $outfile
blank_line

echo -e "..Cleaning ISC DHCP..." | tee -a $outfile
cp -f /multiplatform/Linux/dhtest /usr/bin/
chmod 755 /usr/bin/dhtest
cp -f /multiplatform/Linux/final/dhcpd.conf /etc/dhcp/
check_existence - /etc/dhcp/dhcpd.conf f
check_existence - /usr/bin/dhtest f
systemctl restart isc-dhcp-server

mail_out Final Prep