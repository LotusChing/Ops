#!/bin/bash
set -e
tabs 5

### Variables ###
null="/dev/null"
kernel=`uname -r`
kernel_file="/boot/config-${kernel}"
redhat_release="/etc/redhat-release"
ubuntu_release="/etc/os-release"

Require(){
    echo -e "Required Environment: "
    echo -e "\tOS Platform: [Ubuntu 14.04 LTS| CentOS 6.x| RedHat 6.x]"
    echo -e "\tKernel Version: Null"
    echo -e "\tSpecial Package: Null"
}

OS(){
    [ -f /etc/redhat-release ] && os=`awk '{print $1,$3}' $redhat_release`
    [ -f /etc/os-release ]     && os=`awk -F"\"" '/^P/ {print $2}' $ubuntu_release`
    echo -e "====== OS Information ======"
    echo -e "OS Platform: $os"
    echo -e "Kernel Version: `awk '{print $3}' /proc/version`\n"
}

CPU(){
    physical_core=`grep 'physical id' /proc/cpuinfo | sort -u | wc -l`
    logical_core=`grep 'processor' /proc/cpuinfo |wc -l`
    grep '^flags\b' /proc/cpuinfo | tail -1 | grep -o ht &> $null && hyper_threading=Ture || hyper_threading=False

    echo "====== CPU Information ======"
    echo -e "Physical core: ${physical_core}\nLogical core: ${logical_core}\nHyper-threading: ${hyper_threading}\n"
}

Memory(){
    memory_size_mb=`expr $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1024`
    [ `wc -l /proc/swaps | awk '{print $1}'` -gt 1 ] && swap_size=`expr $(awk 'NR==2 {print $3}' /proc/swaps) / 1024`  || swap_size="0"

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
    for i in $nic_list; do echo -ne "$i: " && ip a s $i | awk '/inet / {split($2,a,"/"); print a[1]}'; done
    echo
}

Timeunit(){
    cpu_hz=`       grep '^CONFIG_HZ=' $kernel_file   | awk -F'=' '{print $2}'`
    time_unit=`    echo "scale=4; 1 / $cpu_hz"       | bc`
    clock_tick_ms=`echo "scale=4; $time_unit * 1000" | bc`

    echo "====== Clock Tick Information ======"
    echo -e "clock_tick: ${clock_tick_ms}ms\n"
}

Help(){
    Require
    echo -e "Usage: bash $0 [OS|CPU|Memory|Disk|Network|Timeunit|All|Help]"
    echo -e "\tOS:        list os platform and kernel version."
    echo -e "\tMemory:    list memory size and swap size."
    echo -e "\tDisk:      list The number of disk and disk size."
    echo -e "\tNetwork:   list network card information and ip address."
    echo -e "\tTimeunit:  list os time unit."
    echo -e "\tAll:       execute all function."
    echo -e "\tHelp:      list script help information."
}

All(){
    OS
    CPU
    Memory
    Disk
    Network
    Timeunit
}

case $1 in 
        OS)
        OS
        ;;
        Memory)
        Memory
        ;;
        Disk)
        Disk
        ;;
        Network)
        Network
        ;;
        Timeunit)
        Timeunit
        ;;
        All)
        All
        ;;
        *)
        Help
        ;;
esac 
