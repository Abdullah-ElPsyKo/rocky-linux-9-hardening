#!/bin/bash

THRESHOLD=80
LOGFILE="/var/log/resource-alerts.log"

echo "🔍 Starting system resource monitor..."
echo "Logging alerts to $LOGFILE"
echo "Started system monitor on $(date)" >> "$LOGFILE"

while true; do
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
        echo "🚨 [$TIMESTAMP] High CPU usage: $CPU_USAGE%" >> "$LOGFILE"
    fi

    if (( $(echo "$MEM_USAGE > $THRESHOLD" | bc -l) )); then
        echo "🚨 [$TIMESTAMP] High RAM usage: $MEM_USAGE%" >> "$LOGFILE"
    fi

    if (( DISK_USAGE > THRESHOLD )); then
        echo "🚨 [$TIMESTAMP] High Disk usage: $DISK_USAGE%" >> "$LOGFILE"
    fi

    sleep 60
done
