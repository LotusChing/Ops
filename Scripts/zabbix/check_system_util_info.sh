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
    free -b | awk '/cache:/ {print $3}'
}

function memory_free(){
    free -b | awk '/cache:/ {print $4}'
}

function tx_kb(){
    tx_bytes=`ifconfig eth0 | awk  '/RX bytes/ {split($2,a,":"); print a[2]}'`
    echo $tx_bytes
}

function rx_kb(){
    rx_bytes=`ifconfig eth0 | awk  '/RX bytes/ {split($6,a,":"); print a[2]}'`
    echo $rx_bytes
}


function established(){
    ss -ant | awk '/ESTAB/ {print $1}'| uniq -c | awk '{print $1}'
}

function timewait(){
    ss -ant | awk '/TIME-WAIT/ {print $1}'| uniq -c | awk '{print $1}'
}

function help(){
    echo """
Usage: bash $0 [function]
functions:
    CPU : [ cpu_util_user | cpu_util_sys | cpu_util_idle ]
    Mem : [ memory_total  | memory_use   | memory_free   ]
    Net : [ rx_bytes      | tx_bytes     | established | timewait ]
    Disk: [ disk_iowait   | disk_ioutil  | disk_size   | disk_use   | disk_free | disk_use_percent]
    """
}
$1
