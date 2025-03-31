#!/bin/bash

echo "Enabling automatic security updates..."

sudo dnf install dnf-automatic -y

sudo sed -i 's/^apply_updates = .*/apply_updates = yes/' /etc/dnf/automatic.conf

sudo systemctl enable --now dnf-automatic.timer