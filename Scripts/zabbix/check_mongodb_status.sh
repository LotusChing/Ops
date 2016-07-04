#!/bin/bash
host=`ip a s eth0 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
user="lotus"
pass=`cat /home/.pass`
db="admin"
null="/dev/null"

function ping(){
    echo "db.serverStatus().opcounters"| mongo $host -u $user -p $pass --authenticationDatabase=$db &> /dev/null && echo 1
}

function insert(){
    echo "db.serverStatus().opcounters"| mongo -u $user -p $pass --authenticationDatabase=$db | awk -F':' '/insert/ {split($2,a,","); print a[1]}'
}

function select(){
    echo "db.serverStatus().opcounters" | mongo -u $user -p $pass --authenticationDatabase=$db   |  awk -F':' '/query/ {split($2,a,","); print a[1]}'
}

function update(){
    echo "db.serverStatus().opcounters" | mongo -u $user -p $pass --authenticationDatabase=$db   |  awk -F':' '/update/ {split($2,a,","); print a[1]}'
}

function delete(){
    echo "db.serverStatus().opcounters" | mongo -u $user -p $pass --authenticationDatabase=$db   |  awk -F':' '/delete/ {split($2,a,","); print a[1]}'
}

function bytesIn(){
    echo "db.serverStatus().network"    |   mongo -u $user -p $pass --authenticationDatabase=$db | grep "bytesIn"     |   egrep -o [0-9]+
}

function bytesOut(){
    echo "db.serverStatus().network"    |   mongo -u $user -p $pass --authenticationDatabase=$db | grep "bytesOut"    | egrep -o [0-9]+
}

function requests(){
    echo "db.serverStatus().network"    |   mongo -u $user -p $pass --authenticationDatabase=$db | grep "numRequests" | egrep -o [0-9]+
}

$1
