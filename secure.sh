#!/bin/bash

LOGFILE="hardening.log"
MODULE_DIR="./modules/"

echo "🔐 Starting Linux hardening..." | tee $LOGFILE

SCRIPTS=(
  "firewall.sh"
  "ssh_hardening.sh"
  "selinux.sh"
  "unused_services.sh"
  "auto_sec_update.sh"
  "auditd_setup.sh"
  "log_monitor.sh"
  "sys_monitor.sh"
)

for script in "${SCRIPTS[@]}"; do
  echo -e "\n🔧 Running: $script" | tee -a $LOGFILE
  if bash "${MODULE_DIR}${script}" >> $LOGFILE 2>&1; then
    echo "✅ Success: $script" | tee -a $LOGFILE
  else
    echo "❌ Error while running: $script" | tee -a $LOGFILE
    exit 1
  fi
done

echo -e "\n✅ Linux hardening completed successfully." | tee -a $LOGFILE