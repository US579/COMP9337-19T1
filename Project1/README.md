# 前言

仅供参考,此project为学习之用,了解破解流程,学习无线安全

system : kali linux

software : aiicrack-ng

# the process of cracking 

##Task2 

Evil Twin AP Attack: Set up a fake AP impersonating the target AP, and force target AP users to connect to it.

### 1. start wireless card monitor mode 

airmon-ng start wlan0

(wlan0 is the port of the wireless network card,it can be check by inputing `ifconfig` or `iwconfig`)


