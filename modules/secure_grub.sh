#!/bin/bash

echo "🔐 Setting GRUB password..."
read -s -p "Enter GRUB password: " GRUB_PASS
echo
read -s -p "Confirm GRUB password: " GRUB_PASS_CONFIRM
echo

if [ "$GRUB_PASS" != "$GRUB_PASS_CONFIRM" ]; then
  echo "❌ Passwords do not match."
  exit 1
fi

# Create PBKDF2 hash
HASH=$(echo -e "$GRUB_PASS\n$GRUB_PASS" | grub2-mkpasswd-pbkdf2 | awk '/grub.pbkdf2/{print $NF}')

# Create /etc/grub.d/01_users
cat <<EOF | sudo tee /etc/grub.d/01_users > /dev/null
#!/bin/sh
cat <<EOF_GRUB
set superusers="admin"
export superusers
password_pbkdf2 admin $HASH
EOF_GRUB
EOF

# Secure the file
sudo chmod 700 /etc/grub.d/01_users

echo "🔁 Rebuilding GRUB config..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "✅ GRUB password configured. Superuser: admin"
