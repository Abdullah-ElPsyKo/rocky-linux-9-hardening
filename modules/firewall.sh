#!/bin/bash

echo "Configuring firewall..."

if command -v ufw &>/dev/null; then
  echo "Using UFW..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw enable

elif command -v firewall-cmd &>/dev/null; then
  echo "Using Firewalld..."
  sudo firewall-cmd --permanent --add-service=ssh
  sudo firewall-cmd --permanent --set-default-zone=public
  sudo firewall-cmd --reload
else
  echo "No firewall detected."
fi
