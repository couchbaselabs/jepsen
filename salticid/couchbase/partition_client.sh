#!/bin/bash 

echo "Drop connections to n3, n4, n5"
iptables -A INPUT -s n3 -j DROP
iptables -A INPUT -s n4 -j DROP
iptables -A INPUT -s n5 -j DROP

echo "Sleep for 30 seconds"
sleep 30

echo "Reconnect to n3, n4, n5"
iptables -F
