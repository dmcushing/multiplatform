#!/bin/bash
#
# Midterm Prep
#

source /multiplatform/Linux/functions.sh

clear
is_super_user
echo -e "Setting up..."
#
# Prep Apache back to defaults
# Copy files for midterm
#
echo -e "..Installing Software..."
apt install -y httpie tree
echo -e "..Cleaning Apache Sites..."
systemctl stop apache2
cp -f /multiplatform/Linux/ssl-server-nopass.key /etc/ssl/ &> /dev/null
chmod 644 /etc/ssl/ssl-server-nopass.key
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
a2enmod ssl &> /dev/null
systemctl start apache2
apache2ctl -t -D DUMP_VHOSTS
blank_line
#
# Prep Bind back to defaults
# Copy files for midterm
#
echo -e "....Cleaning Bind Settings..."
blank_line
systemctl stop bind9
mv /etc/bind/named.conf.options /etc/bind/named.conf.options.pre-midterm
mv /etc/bind/named.conf.local /etc/bind/named.conf.local.pre-midterm
cp /multiplatform/Linux/midterm/named.conf.options.midterm /etc/bind/named.conf.options
chown root:bind /etc/bind/named.conf.options
chmod 644 /etc/bind/named.conf.options
cp /multiplatform/Linux/midterm/named.conf.local.midterm /etc/bind/named.conf.local
chown root:bind /etc/bind/named.conf.local
chmod 644 /etc/bind/named.conf.local
cp /multiplatform/Linux/midterm/midterm.org /var/cache/bind/
chmod 644 /var/cache/bind/midterm.org
systemctl start bind9
named-checkconf -z /etc/bind/named.conf
blank_line
dig @localhost +noall +answer ns1.midterm.org
dig @localhost +noall +answer ns2.midterm.org
dig @localhost +noall +answer ubuntu1804.midterm.org
dig @localhost +noall +answer windows2016.midterm.org
dig @localhost +noall +answer host1.midterm.org
dig @localhost +noall +answer host2.midterm.org
