#!/bin/bash

# Log file path (replace with the actual path if needed)
LOG_FILE="/var/log/nginx/access.log"

# Output file path
OUTPUT_FILE="/root/ip.sh"

# Threshold for blocking IPs (1000 hits)
THRESHOLD=1000

# Temporary file to store IPs to be blocked
TEMP_FILE="/tmp/blocked_ips.txt"

# Extract IP addresses and count occurrences
awk '{print $8}' $LOG_FILE | sort | uniq -c | sort -nr > $OUTPUT_FILE

# Display the results
cat $OUTPUT_FILE

# Check for IPs that exceed the threshold and block them
awk -v threshold="$THRESHOLD" '$1 > threshold {print $2}' $OUTPUT_FILE > $TEMP_FILE

# Block IPs that exceed the threshold using iptables
while read -r IP; do
  # Check if the IP is already blocked
  iptables -C INPUT -s "$IP" -j DROP 2>/dev/null
  if [ $? -ne 0 ]; then
    # Block the IP if it's not already blocked
    iptables -A INPUT -s "$IP" -j DROP
    echo "Blocked IP: $IP"
  else
    echo "IP already blocked: $IP"
  fi
done < $TEMP_FILE

# Clean up temporary file
rm -f $TEMP_FILE
