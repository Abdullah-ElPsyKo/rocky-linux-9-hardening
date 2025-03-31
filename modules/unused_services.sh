#!/bin/bash

echo "Disabling unnecessary services..."

services=("avahi-daemon" "cups" "bluetooth")

for service in "${services[@]}"; do
  if systemctl list-unit-files | grep -q "^$service.service"; then
    if systemctl is-enabled --quiet "$service"; then
      sudo systemctl disable --now "$service"
      echo "Disabled $service"
    else
      echo "$service is already disabled"
    fi
  else
    echo "$service does not exist, skipping..."
  fi
done
