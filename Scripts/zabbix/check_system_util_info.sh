#!/bin/bash

#system_util_info=`top -bn2 | awk '/Cpu/' | tail -1 `

cpu_cmd="top -bn2 | awk '/Cpu/'"

function cpu_util_user(){
    top -bn2 | awk '/Cpu/' | tail -1 | awk '{split($2,a,"%"); print a[1]}'
}

function cpu_util_sys(){
    top -bn2 | awk '/Cpu/' | tail -1 | awk '{split($3,a,"%"); print a[1]}' 
}

function cpu_util_idle(){
    top -bn2 | awk '/Cpu/' | tail -1 | awk '{split($5,a,"%"); print a[1]}' 
}

function disk_iowait(){
    top -bn2 | awk '/Cpu/' | tail -1 | awk '{split($6,a,"%"); print a[1]}' 
}

function disk_ioutil(){
    iostat -dkx sda 1 2 | sed -rn '7p' | awk '{print $NF}'
}

function disk_use_percent(){
    df -Ph | awk '/\/$/ {split($5,a,"%"); print a[1]}'
}

function disk_size(){
    df -Ph | awk '/\/$/ {split($2,a,"G"); print a[1]}'
}

function disk_use(){
    df -Ph | awk '/\/$/ {split($3,a,"G"); print a[1]}'
}

function disk_free(){
    df -Ph | awk '/\/$/ {split($4,a,"G"); print a[1]}'
}

function memory_total(){
    free -m | awk '/Mem/ {print $2}'
}

function memory_use(){
    free -m | awk '/cache:/ {print $3}'
}

function memory_free(){
    free -m | awk '/cache:/ {print $4}'
}

function rx_bytes(){
    rbps=` cat /sys/class/net/eth0/statistics/rx_bytes`
    rkbps=`expr $rbps / 1024`
    echo $rkbps
}

function tx_bytes(){
    tbps=` cat /sys/class/net/eth0/statistics/tx_bytes`
    tkbps=`expr $tbps / 1024`
    echo $tkbps
}

function rx_packets(){
    rpkts=`cat /sys/class/net/eth0/statistics/rx_packets`
    echo $rpkts
}

function tx_packets(){
    tpkts=`cat /sys/class/net/eth0/statistics/tx_packets`
    echo $tpkts
}

function help(){
    echo """
Usage: bash $0 [function]
functions:
    CPU : [ cpu_util_user | cpu_util_sys | cpu_util_idle ]
    Mem : [ memory_total  | memory_use   | memory_free   ]
    Net : [ rx_bytes      | tx_bytes     | rx_packets  | tx_packets ]
    Disk: [ disk_iowait   | disk_ioutil  | disk_size   | disk_use   | disk_free | disk_use_percent]
    """
}
$1
