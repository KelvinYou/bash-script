#!/bin/bash

hih2_log_file="../../hlh2/hlh.log"

if [ ! -f "$hih2_log_file" ]; then
  echo "Log file not found: $hih2_log_file"
  exit 1
fi

while true; do
  last_line=$(tail -n 1 "$hih2_log_file")

  echo "last_line: $last_line"

  if echo "$last_line" | grep -q "Summary"; then
    break
  fi

  sleep 2
done
