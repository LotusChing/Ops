#!/bin/bash
user=root
pass=`cat /home/.pass`
null=/dev/null
cmd="mysqladmin -u$user -p$pass extended-status"

function ping {
    mysqladmin -u$user -p$pass ping &> $null && echo 1
}

function connected {
    $cmd | awk '/Threads_connected/ {print $4}'
}

function select {
    $cmd | awk '/Com_select/ {print $4}'
}

function insert {
    $cmd | awk '/Com_insert / {print $4}'
}

function update {
    $cmd | awk '/Com_update / {print $4}'
}

function delete {
    $cmd | awk '/Com_delete / {print $4}'
}

function qps {
    $cmd | awk '/Queries/ {print $4}'
}

function tps {
    commit=`$cmd | awk '/Com_commit/    {print $4}'`
    rollback=`$cmd | awk '/Com_rollback / {print $4}'`
    sum=`expr $commit + $rollback`
    echo "$sum"
}

function commit {
    $cmd | awk '/Com_commit/    {print $4}'
}

function rollback {
    $cmd | awk '/Com_rollback / {print $4}'
}

function bytes_sent {
    $cmd | awk '/Bytes_sent/ {print $4}'
}

function bytes_received {
    $cmd | awk '/Bytes_received/ {print $4}'
}


function help(){
    echo """
Usage: bash $0 [function]
functions:
    [ ping | connected | select | insert | update | delete | qps | tps | commit | rollback | bytes_sent | bytes_recevied ]
    """
}

$1
