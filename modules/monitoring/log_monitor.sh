#!/bin/bash

SRC_LOG="/var/log/secure"
OUT_LOG="/var/log/ssh-alerts.log"

echo "🔍 Monitoring $SRC_LOG for failed SSH logins..."
echo "Logging alerts to $OUT_LOG"
echo "Started log monitoring on $(date)" >> "$OUT_LOG"

tail -Fn0 "$SRC_LOG" | while read -r line; do
  echo "$line" | grep "Failed password" &>/dev/null
  if [[ $? -eq 0 ]]; then
    IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    USER=$(echo "$line" | grep -oP 'for (invalid user )?\K\S+' | tail -n1)
    TIMESTAMP=$(echo "$line" | cut -d ' ' -f1-3)

    echo "WARNING [$TIMESTAMP] Failed login for user '$USER' from IP $IP" >> "$OUT_LOG"
  fi
done
