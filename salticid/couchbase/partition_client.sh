#!/bin/bash 
iptables -A INPUT -s n3 -j DROP
iptables -A INPUT -s n4 -j DROP
iptables -A INPUT -s n5 -j DROP
