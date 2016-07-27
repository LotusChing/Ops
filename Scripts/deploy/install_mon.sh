#!/bin/bash
set -e

echo "###### Download and Compile Mon"
cd /tmp/ && git clone https://github.com/tj/mon.git &> /dev/null && cd mon && make install
cp /tmp/mon/mon /bin/ && echo "Install Mon OK!" || echo "Install Mon Error!"
