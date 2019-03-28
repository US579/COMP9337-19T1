# 前言

仅供参考,此project为学习之用,了解破解流程,学习无线安全

system : kali linux

software : aiicrack-ng

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

## 3. attack target by using aireplay-ng
```
aireplay-ng -0 0 -a C4:71:54:23:2A:AE -c EC:D0:9F:87:DD:6F  wlan0mon
```

-0 : Conflict attack mode , follow by the attack times , 0 represent all the times

-a : the MAC of AP  , this can be captured from the `airodump-ng wlan0mon`

-c : the client that connect to AP legally. if not spcecif which client , it will disconnect all the clients which connect to this WI-FI

the client will be disconnected from the AP we input above 


