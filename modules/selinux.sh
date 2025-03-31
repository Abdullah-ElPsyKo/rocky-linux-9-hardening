#!/bin/bash
echo "Enforcing SELinux..."
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
setenforce 1
