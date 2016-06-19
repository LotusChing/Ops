#!/bin/bash
user=root
pass=`cat /root/.pass`
null=/dev/null
cmd="mysqladmin -u$user -p$pass extended-status"

function ping {
    mysqladmin -u$user -p$pass ping &> $null && echo 1
}

function connected {
    $cmd | awk '/Threads_connected/ {print $4}'
}

function select {
    $cmd | awk '/Innodb_rows_read/ {print $4}'
}

function insert {
    $cmd | awk '/Innodb_rows_inserted/ {print $4}'
}

function update {
    $cmd | awk '/Innodb_rows_updated/ {print $4}'
}

function insert {
    $cmd | awk '/Innodb_rows_deleted/ {print $4}'
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

function help(){
    echo """
Usage: bash $0 [function]
functions:
    [ ping | connected | select | insert | update | delete | qps | tps ]
    """
}

$1
