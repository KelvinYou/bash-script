#!/bin/bash

log_file="../../merchant-sync/merchant-sync.log"

if [ ! -f "$log_file" ]; then
  echo "Log file not found: $log_file"
  exit 1
fi

while true; do
  last_line=$(tail -n 1 "$log_file")

  echo "last_line: $last_line"

  if echo "$last_line" | grep -q "Current depth: 0"; then
    break
  fi

  sleep 2
done
