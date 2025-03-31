#!/bin/bash
echo "Installing auditd..."
sudo dnf install audit -y
sudo systemctl enable -- auditd