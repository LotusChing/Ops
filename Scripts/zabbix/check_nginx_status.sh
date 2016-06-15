#!/bin/bash
# DateTime: 2015-11-19 11:30
HOST="127.0.0.1"
PORT="80"
PAGE="health"

function ping {
   /usr/bin/elinks -dump $HOST$PORT/$PAGE |wc -l
}

function active-connections {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk '/Active/ {print $3}'
}

function process-conn {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk ' NR==3 {print $1} '
}

function accepts-handled {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk ' NR==3 {print $2} '
}

function process-request {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk ' NR==3 {print $3} '
}

function process-request-time {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk ' NR==3 {print $4} '
}

function reading-client-header {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk '/Reading/ {print $2}'
}

function writing-client-header {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk '/Writing/ {print $4}'
}

function waiting-request {
   /usr/bin/curl -s http://$HOST:$PORT/status | awk '/Waiting/ {print $6}'
}

function help(){
    echo """
Usage: bash $0 [function]
functions:
    [ ping | active-connections | process-conn | accepts-handled | process-request | process-request-time | reading-client-header | writing-client-header | waiting-request ]
    """
}
$1
