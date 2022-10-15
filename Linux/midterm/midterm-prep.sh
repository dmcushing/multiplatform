#!/bin/bash
#
# Midterm Prep
#

source /multiplatform/Linux/functions.sh

clear
is_super_user
student_info Midterm Prep

echo -e "Setting up..."
#
# Prep Apache back to defaults
# Copy files for midterm
#
echo -e "..Installing Software..." | tee -a $outfile
apt -y install httpie tree
clear
check_existence - /usr/bin/tree f
check_existence - /usr/bin/http f
blank_line
echo -e "..Cleaning Apache Sites..." | tee -a $outfile
systemctl stop apache2
cp -f /multiplatform/Linux/ssl-server-nopass.key /etc/ssl/ &> /dev/null
chmod 644 /etc/ssl/ssl-server-nopass.key
cp -f /multiplatform/Linux/midterm/lnxX.midterm.org.pem /etc/ssl/ &> /dev/null
cp -f /multiplatform/Linux/midterm/lnx1.midterm.org.pem /etc/ssl/ &> /dev/null
cp -f /multiplatform/Linux/midterm/lnx2.midterm.org.pem /etc/ssl/ &> /dev/null
chmod 644 /etc/ssl/lnx*.midterm.org.pem
mkdir -p /etc/apache2/sites-enabled/midterm_backup &> /dev/null
mkdir -p /var/www/midterm.org &> /dev/null
mv /etc/apache2/sites-enabled/[!0]*.conf /etc/apache2/sites-enabled/midterm_backup/ &> /dev/null
cp -f /multiplatform/Linux/midterm/midterm.org.conf /etc/apache2/sites-enabled/
cp -f /multiplatform/Linux/midterm/apacheindex.html /var/www/midterm.org/index.html
cp -f /multiplatform/Linux/midterm/apacherror.html /var/www/midterm.org/
chmod 666 /etc/apache2/sites-enabled/midterm.org.conf
chmod 666 /var/www/midterm.org/index.html
chmod 666 /var/www/midterm.org/apacherror.html
check_existence - /etc/ssl/ssl-server-nopass.key f
check_existence - /etc/ssl/lnx1.midterm.org.pem f
check_existence - /etc/ssl/lnx2.midterm.org.pem f
check_existence - /etc/apache2/sites-enabled/midterm.org.conf f
check_existence - /var/www/midterm.org/index.html f
check_existence - /var/www/midterm.org/apacherror.html f
a2enmod ssl &> /dev/null
systemctl start apache2
blank_line
apache2ctl -t -D DUMP_VHOSTS | tee -a $outfile
blank_line
#
# Prep Bind back to defaults
# Copy files for midterm
#
echo -e "....Cleaning Bind Settings..." | tee -a $outfile
blank_line
systemctl stop named
mv /etc/bind/named.conf.options /etc/bind/named.conf.options.pre-midterm
mv /etc/bind/named.conf.local /etc/bind/named.conf.local.pre-midterm
cp /multiplatform/Linux/midterm/named.conf.options.midterm /etc/bind/named.conf.options
chown root:bind /etc/bind/named.conf.options
chmod 644 /etc/bind/named.conf.options
cp /multiplatform/Linux/midterm/named.conf.local.midterm /etc/bind/named.conf.local
chown root:bind /etc/bind/named.conf.local
chmod 644 /etc/bind/named.conf.local
systemctl start named
cat /etc/bind/named.conf.local | tee -a $outfile
blank_line

mail_out CET2420 Midterm_Prep