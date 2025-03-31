#!/bin/bash

echo "🔒 Disabling empty password logins..."

if grep -q "^PermitEmptyPasswords" /etc/ssh/sshd_config; then
    sudo sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
else
    echo "PermitEmptyPasswords no" | sudo tee -a /etc/ssh/sshd_config
fi

echo "🔁 Restarting SSH service..."
sudo systemctl restart sshd

echo "✅ Empty password logins disabled."
