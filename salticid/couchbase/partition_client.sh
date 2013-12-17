#!/bin/bash 

echo "Drop connections to n1, n2"
iptables -A INPUT -s n1 -j DROP
iptables -A INPUT -s n2 -j DROP

echo "Sleep for 30 seconds"
sleep 30

echo "Reconnect to n1, n2"
iptables -F
