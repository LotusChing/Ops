#!/bin/bash
HOST=`ip a s eth0 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
PORT="8080"
null="/dev/null"

function ping(){
    elinks -dump $HOST:$PORT &> $null && echo "1"
}

$1
