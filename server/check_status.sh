#!/bin/bash
log_file=../MQPOSPAYMENT.log
request_code=0210

if [ ! -f "$log_file" ]; then
  echo "Log file not found: $log_file"
  exit 1
fi

while true; do
  if grep -q "DE0: $request_code" "$log_file"; then
    last_de0_line=$(grep "DE0: $request_code" "$log_file" | tail -n 1)
    de0_line_number=$(awk '/DE0: '"$request_code"'/{line=NR} END{print line}' "$log_file")
    de39_line=$(awk -v de0_line_num="$de0_line_number" 'NR > de0_line_num && /DE39:/ {print $0; exit}' "$log_file")
    
    echo "last_de0_line: $last_de0_line"
    echo "de0_line_number: $de0_line_number"
    echo "de39_line: $de39_line"
    
    if [[ -n $de39_line ]]; then
      if [[ $de39_line == *"DE39: 17"* ]]; then
        echo "No pending transaction"
        break
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
