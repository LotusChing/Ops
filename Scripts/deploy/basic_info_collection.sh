#!/bin/bash
set -e
internal_ip=` ip a s eth2 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
os_version=`  awk '{print $1,$3}' /etc/redhat-release`
cpu_cores=`   grep "cores" /proc/cpuinfo |wc -l`
memory_size=` free -g|awk '/Mem/ {print $2}'`
disk_util=`   fdisk -l|awk '/Disk \/dev\/sda|vda|xvda/ {print $2, $3}'`
            #`fdisk -l|awk '/Disk \/dev/ {print $2"\b "}'`

echo -e """
内网IP: $internal_ip
U/P:    root/root123123
OS:     $os_version
CPU:    ${cpu_cores}Core
MEM:    ${memory_size}G
DISK:   ${disk_util}"""
