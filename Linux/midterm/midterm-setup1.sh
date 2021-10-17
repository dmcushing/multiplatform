#!/bin/bash
#
# Midterm Set Up
#

#
# Functions
#
blank_line(){
echo -e "\n" | tee -a $outfile
return 0
}

is_super_user(){
	if [ $EUID -ne 0 ]
then
        echo "Insufficient permissions. Run this script as root, or with sudo."
        exit 1
else
	return 0
fi
}

clear
is_super_user
echo -e "[[[[ BEGIN CUT AND PASTE ]]]]"
blank_line
echo -e "Setting up..."
#
# Prep Apache back to defaults
# Copy files for midterm
#
echo -e "..Cleaning Apache Sites..."
systemctl apache2 stop
cp /multiplatform/Linux/ssl-server-nopass.key /etc/ssl/
chmod 644 /etc/ssl/Linux/ssl-server-nopass.key
cp /multiplatform/Linux/www.midterm.org.pem /etc/ssl/
chmod 644 /etc/ssl/www.midterm.org.pem
mkdir /etc/apache2/sites-enabled/midterm_backup
mkdir /var/www/midterm.org
mv /etc/apache2/sites-enabled/*.conf /etc/apache2/sites-enabled/midterm_backup/
ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
blank_line
a2enmod ssl
systemctl start apache2
apache2ctl -t -D DUMP_VHOSTS
#
# Prep Bind back to defaults
# Copy files for midterm
#
echo -e "....Cleaning Bind Settings..."
systemctl stop bind9
iptables -I INPUT -s localhost -d 127.0.0.53 -j ACCEPT
mv /etc/bind/named.conf.options /etc/bind/named.conf.options.midterm
mv /etc/bind/named.conf.local /etc/bind/named.conf.local.midterm
cp /multiplatform/Linux/midterm/named.conf.options.midterm /etc/bind/named.conf.options
chown root:bind /etc/bind/named.conf.options
chmod 644 /etc/bind/named.conf.options
cp /multiplatform/Linux/midterm/named.conf.local.midterm /etc/bind/named.conf.local
chown root:bind /etc/bind/named.conf.local
chmod 644 /etc/bind/named.conf.local
cp /multiplatform/Linux/midterm.org /var/cache/bind/
chmod 644 /var/cache/bind/midterm.org
cp /multiplatform/Linux/example.com /var/cache/bind/
chmod 644 /var/cache/bind/example.com
systemctl start bind9
named-checkconf -z /etc/bind/named.conf
blank_line
dig @localhost +noall +answer ns1.midterm.org
dig @localhost +noall +answer ns2.midterm.org
dig @localhost +noall +answer ubuntu1804.midterm.org
dig @localhost +noall +answer windows2016.midterm.org
dig @localhost +noall +answer host1.midterm.org
dig @localhost +noall +answer host2.midterm.org
echo -e "[[[[ END CUT AND PASTE ]]]]"
