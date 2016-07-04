#!/bin/bash

wget -O /etc/yum.repos.d/PUIAS_6_computational.repo https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/install/centos/PUIAS_6_computational.repo
sed -r -i '6c gpgcheck=1' /etc/yum.repos.d/PUIAS_6_computational.repo
yum repolist && yum -y update git
