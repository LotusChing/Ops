#!/bin/bash
set -e

### Variables ###
null="/dev/null"

### Kernel Version ###
kernel=`uname -r`
kernel_file="/boot/config-${kernel}"

### CPU Information
CPU(){
    physical_core=`grep 'physical id' /proc/cpuinfo | sort -u | wc -l`
    logical_core=`grep 'processor' /proc/cpuinfo |wc -l`
    grep '^flags\b' /proc/cpuinfo | tail -1 | grep -o ht &> $null && hyper_threading=Ture || hyper_threading=False

    echo "====== CPU Information ======"
    echo -e "Physical core: ${physical_core}\nLogical core: ${logical_core}\nHyper-threading: ${hyper_threading}\n"
}

Memory(){
    memory_size_mb=`expr $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1024`
    swap_size=`expr $(awk 'NR==2 {print $3}' /proc/swaps) / 1024`

    echo "====== Memory Information ======"
    echo -e "Memory Size: $memory_size_mb MB\nSwap Size: $swap_size MB\n"
}

Disk(){
    disk_size=`awk '$4 !~ /dm/ && $2==0 {print $4":",$3 / 1024000 " GB"}' /proc/partitions`

    echo "====== Disk Information ======"
    echo -e "$disk_size \n"
   
}

Network(){
    nic_list=`awk '/ eth[0-9]+/ {split($1, a, ":"); print a[1]}' /proc/net/dev`

    echo "====== NIC Information ======"
    for i in $nic_list; do echo -ne "$i: \t" && ip a s $i | awk '/inet / {split($2,a,"/"); print a[1]}'; done
    echo
}

Timeunit(){
    cpu_hz=`       grep '^CONFIG_HZ=' $kernel_file   | awk -F'=' '{print $2}'`
    time_unit=`    echo "scale=4; 1 / $cpu_hz"       | bc`
    clock_tick_ms=`echo "scale=4; $time_unit * 1000" | bc`

    echo "====== Clock Tick Information ======"
    echo -e "clock_tick: ${clock_tick_ms}ms\n"
}

All(){
    CPU
    Memory
    Disk
    Network
    Timeunit
}
$1
