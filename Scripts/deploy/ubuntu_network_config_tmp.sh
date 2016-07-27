#!/bin/bash
set -e 
green="\033[32m"
red="\033[31m"
over="\033[0m"

local_ip=`ip a s eth0 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
local_gw=`route -n | awk '/UG/ {print $2}'`
interface_conf="/etc/network/interfaces"
domain_conf="/etc/resolv.conf"

# backup default network config 
echo "Backup default network interface config..."
cp /etc/network/interfaces /etc/network/interfaces.bak

# config domain server
echo "Configure DNS interface config..."
echo -e "nameserver 223.5.5.5\nnameserver 223.6.6.6" > $domain_conf

# generate new config
echo "Generate new network config..."
cat > $interface_conf << Da
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address $local_ip
netmask 255.255.255.0
gateway $local_gw
Da

# restart network
echo "Restart network for load new config..."
ifdown eth0  && ifup eth0 
[ $? -eq 0 ] && echo -e "Network Config \t ${green}[OK]${over}" || echo -e "Network Config \t ${red}[Failed]${over}"
