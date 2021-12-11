#!/bin/bash

# 2420 Final Exam Prep Script

source /multiplatform/Linux/functions.sh

clear
is_super_user

echo -e "Starting Setup.."
apt -y install httpie resolvconf 2>&1>/dev/null

echo "nameserver 127.0.0.1" > /etc/resolvconf/resolv.conf.d/tail
cp -f /multiplatform/Linux/final/resolved.conf /etc/systemd/
systemctl restart systemd-resolved

mkdir -p /var/www/cet2420-final.org
cp -f /etc/bind/named.conf.local /etc/bind/named.conf.local.orig
cp -f /multiplatform/Linux/final/named.conf.local /etc/bind/
cp -f /multiplatform/Linux/final/cet2420-final.org /var/cache/bind/
cp -f /multiplatform/Linux/final/bind9 /etc/default/
systemctl restart bind9

cp /multiplatform/Linux/final/cet2420-final.org.conf /etc/apache2/sites-enabled/
cp /multiplatform/Linux/final/cet2420-final.org.key /etc/ssl/cet2420-final.org.key
cp /multiplatform/Linux/final/cet2420-final.org.pem /etc/ssl/cet2420-final.org.pem
chmod 644 /etc/ssl/cet2420-final.org.key
chmod 644 /etc/ssl/cet2420-final.org.pem
systemctl restart apache2

cp /multiplatform/Linux/dhtest /usr/bin/
chmod 755 /usr/bin/dhtest
cp /multiplatform/Linux/final/dhcpd.conf /etc/dhcp/
systemctl restart isc-dhcp-server

echo -e "Rebooting in 10 seconds..."
sleep 10
reboot