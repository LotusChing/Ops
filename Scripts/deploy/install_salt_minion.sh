#!/bin/bash
yum -y install salt salt-minion
sed -r -i '16c master: 192.168.1.117' /etc/salt/minion
