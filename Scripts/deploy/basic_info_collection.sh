#!/bin/bash
set -e

### Hardware Information ###
            #`fdisk -l|awk '/Disk \/dev/ {print $2"\b "}'`

### Performance Information ###


wiki(){
    internal_ip=` ip a s eth2 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
    os_version=`  awk '{print $1,$3}' /etc/redhat-release`
    cpu_cores=`   grep "cores" /proc/cpuinfo |wc -l`
    memory_size=` free -g|awk '/Mem/ {print $2}'`
    disk_util=`   fdisk -l|awk '/Disk \/dev\/sda|vda|xvda/ {print $2, $3}'`
    echo -e """
    内网IP: $internal_ip
    U/P:    root/root123123
    OS:     $os_version
    CPU:    ${cpu_cores}Core
    MEM:    ${memory_size}G
    DISK:   ${disk_util}
"""
}


timeunit(){
    cpu_hz=`grep '^CONFIG_HZ=' /boot/config-2.6.32-431.el6.x86_64|awk -F'=' '{print $2}'`
    time_unit=`echo "scale=4; 1 / $cpu_hz" | bc`
    clock_tick_ms=`echo "scale=4; $time_unit * 1000" | bc`
    echo "clock_tick: ${clock_tick_ms}ms"
}


$1
