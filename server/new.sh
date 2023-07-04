#!/bin/bash

# shutdown server
mqpospayment_log_file=../MQPOSPAYMENT.log
request_code=0210
hlh_log_file="../../hlh/hlh.log"
hlh2_log_file="../../hlh2/hlh.log"
merchant_sync_log_file="../../merchant-sync/merchant-sync.log"

if [ ! -f "$mqpospayment_log_file" ]; then
  echo "Log file not found: $mqpospayment_log_file"
  exit 1
fi

while true; do
  if grep -q "DE0: $request_code" "$mqpospayment_log_file"; then
    last_de0_line=$(grep "DE0: $request_code" "$mqpospayment_log_file" | tail -n 1)
    de0_line_number=$(awk '/DE0: '"$request_code"'/ {line=NR} END{print line}' "$mqpospayment_log_file")
    de39_line=$(awk -v de0_line_num="$de0_line_number" 'NR > de0_line_num && /DE39:/ {print $0; exit}' "$mqpospayment_log_file")
    
    echo "last_de0_line: $last_de0_line"
    echo "de39_line: $de39_line"
    
    if [[ -n $de39_line ]]; then
      if [[ $de39_line == *"DE39: 17"* ]]; then
        echo "No pending transaction"
        
        current_timestamp=$(date +%s)
        de39_timestamp=$(date -d "$(echo "$de39_line" | cut -d' ' -f1,2 | sed 's/,/./')" +%s)
        time_difference=$((current_timestamp - de39_timestamp))
        
        if ((time_difference < 10)); then
          echo "Less than 10 seconds"
        else
          echo "Shut down server"
          break;
        fi
      else
        echo "Waiting..."
        sleep 2
        # break
      fi
    else
      echo "DE39 value not found"
      break
    fi
  else
    echo "No DE0: $request_code found in the log file"
    break
  fi
done

# shutdown hlh, hlh2 and merchant sync
check_log_file() {
  local log_file="$1"
  local search_string="$2"

  if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    exit 1
  fi

  while true; do
    last_line=$(tail -n 1 "$log_file")

    echo "last_line: $last_line"

    if echo "$last_line" | grep -q "$search_string"; then
      echo "Shut down $log_file"
      break
    fi

    sleep 2
  done
}

check_log_file "$hlh_log_file" "Summary"
check_log_file "$hlh2_log_file" "Summary"
check_log_file "$merchant_sync_log_file" "Current depth: 0"
