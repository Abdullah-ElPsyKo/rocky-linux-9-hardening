#!/bin/bash

echo "[Authselect] Securing PAM: Prevent logins with empty passwords..."

# Check if authselect is installed
if ! command -v authselect &>/dev/null; then
  echo "authselect not found. Install it before running this script."
  exit 1
fi

# Check if authselect is already in use
if authselect current | grep -q 'No existing configuration detected'; then
  echo "No authselect profile active. Initializing with secure defaults (sssd)..."
  sudo authselect select sssd --force
else
  echo "Existing authselect profile detected."
fi

# Enable the without-nullok feature
if authselect current | grep -q without-nullok; then
  echo "'without-nullok' is already enabled."
else
  echo "Enabling 'without-nullok' feature..."
  sudo authselect enable-feature without-nullok
  sudo authselect apply-changes
fi

# Confirmation
echo "Verifying PAM files for 'nullok'..."
if grep -q nullok /etc/pam.d/system-auth /etc/pam.d/password-auth; then
  echo "'nullok' still found! Something went wrong."
  exit 1
else
  echo "'nullok' successfully removed. PAM is hardened against empty passwords."
fi
