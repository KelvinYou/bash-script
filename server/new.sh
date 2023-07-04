#!/bin/bash

# file path
mqpospayment_log_file=../MQPOSPAYMENT.log
hlh_log_file="../../hlh/hlh.log"
hlh2_log_file="../../hlh2/hlh.log"
merchant_sync_log_file="../../merchant-sync/merchant-sync.log"

#req & res
request_code=0200
response_code=0210

# PIDs
mqpospayment_pid=$(ps -ef | pgrep -f /disk1/tomcat-instances/fnx-fintech-mqpos)
merc_sync_pid=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos/fnx-merchant-sync/lib/)
hlh_pid=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos-hlh/bin/hsm.properties)
hlh2_pid=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos-hlh2/bin/hsm.properties)

# General
sleep_time=5

# shutdown server
if [ ! -f "$mqpospayment_log_file" ]; then
  echo "Log file not found: $mqpospayment_log_file"
  exit 1
fi

while true; do
  if grep -q "DE0: $response_code" "$mqpospayment_log_file"; then
    last_request_de0_line=$(grep "DE0: $request_code" "$mqpospayment_log_file" | tail -n 1)
    response_de0_line_number=$(awk '/DE0: '"$response_code"'/ {line=NR} END{print line}' "$mqpospayment_log_file")
    response_de39_line=$(awk -v de0_line_num="$response_de0_line_number" 'NR > de0_line_num && /DE39:/ {print $0; exit}' "$mqpospayment_log_file")
    
    echo "last_request_de0_line: $last_request_de0_line"
    echo "response_de39_line: $response_de39_line"
    
    if [[ -n $response_de39_line ]]; then
      if [[ $response_de39_line == *"DE39: 17"* ]]; then
        echo "No pending transaction"
        
        current_timestamp=$(date +%s)
        request_de0_timestamp=$(date -d "$(echo "$last_request_de0_line" | cut -d' ' -f1,2 | sed 's/,/./')" +%s)
        response_de39_timestamp=$(date -d "$(echo "$response_de39_line" | cut -d' ' -f1,2 | sed 's/,/./')" +%s)
        time_difference_request=$((current_timestamp - request_de0_timestamp))
        time_difference_response=$((current_timestamp - response_de39_timestamp))
        
        if ((time_difference_response < 10)); then
          echo "Less than 10 seconds"
          sleep $sleep_time
        else
          if ((time_difference_request < 10)); then
            echo "New request"
            sleep $sleep_time
          else  
            echo "Shut down server: $mqpospayment_pid"
            break;
          fi
        fi
      else
        echo "Waiting..."
        sleep $sleep_time
      fi
    else
      echo "DE39 value not found"
      break
    fi
  else
    echo "No DE0: $response_code found in the log file"
    break
  fi
done

# shutdown hlh, hlh2 and merchant sync
check_log_file() {
  local log_file="$1"
  local search_string="$2"
  local pid="$3"

  if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    exit 1
  fi

  while true; do
    last_line=$(tail -n 1 "$log_file")

    echo "last_line: $last_line"

    if echo "$last_line" | grep -q "$search_string"; then
      echo "Shut down: $pid"
      break
    fi

    sleep $sleep_time
  done
}

check_log_file "$hlh_log_file" "Summary" "$hlh_pid"
check_log_file "$hlh2_log_file" "Summary" "$hlh2_pid"
check_log_file "$merchant_sync_log_file" "Current depth: 0" "$merc_sync_pid"
