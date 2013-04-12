#!/bin/bash

iptables -F
iptables -N WEBIN
iptables -N WEBOUT
iptables -N SSHIN
iptables -N SSHOUT
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P WEBIN ACCEPT
iptables -P WEBOUT ACCEPT
iptables -P SSHIN ACCEPT
iptables -P SSHOUT ACCEPT

iptables -A WEBIN -p tcp -j ACCEPT;
iptables -A WEBOUT -p tcp -j ACCEPT;

iptables -A SSHIN -p tcp -j ACCEPT;
iptables -A SSHOUT -p tcp -j ACCEPT;

iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

iptables -A INPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT

iptables -A INPUT -p tcp -i p6p1 -s 0/0 --sport 0:1023 -d 192.168.0.0/24 --dport 80 -j DROP

iptables -A INPUT -p tcp -i p6p1 -s 0/0 -d 192.168.0.0/24 --sport 80 -m state --state ESTABLISHED,NEW -j ACCEPT
iptables -A OUTPUT -p tcp -o p6p1 -s 192.168.0.0/24 -d 0/0 --dport 80 -m state --state ESTABLISHED,NEW -j ACCEPT

iptables -A INPUT -p tcp -i p6p1 -s 0/0 -d 192.168.0.0/24 --dport 22 -m state --state ESTABLISHED,NEW -j ACCEPT
iptables -A OUTPUT -p tcp -o p6p1 -s 192.168.0.0/24  -d 0/0 --sport 22 -m state --state ESTABLISHED,NEW -j ACCEPT

iptables -A INPUT -p tcp --syn -j DROP

iptables -A INPUT -i p6p1 -p tcp --dport 0 -j DROP 
iptables -A OUTPUT -o p6p1 -p tcp --sport 0 -j DROP 

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

service iptables save
service iptables restart

#iptables -nvx -L FORWARD