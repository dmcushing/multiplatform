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
echo -e "Setting up.."
#
# Copy files for midterm
#
echo -e "---Apache Midterm Site---"
cp -f /multiplatform/Linux/midterm/midterm.org.conf /etc/apache2/sites-enabled/
cp -f /multiplatform/Linux/midterm/apacheindex.html /var/www/midterm.org/index.html
cp -f /multiplatform/Linux/midterm/apacherror.html /var/www/midterm.org/
cp -f /multiplatform/Linux/midterm/midterm.org /var/cache/bind/
chmod 644 /var/cache/bind/midterm.org
chmod 666 /etc/apache2/sites-enabled/midterm.org.conf
chmod 666 /var/www/midterm.org/index.html
chmod 666 /var/www/midterm.org/apacherror.html
mv /etc/resolv.conf /etc/resolv.conf.orig
ln -s /multiplatform/resolv.conf /etc/resolv.conf 2>/dev/null
apt -y update
apt -y install httpie
blank_line
echo -e "Done.."
