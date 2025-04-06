#!/bin/bash

# Mr-Awel's Suspicious Log Analyzer v0.1
# Analyzes logs for failed login attempts and weird IPs.

LOGFILE=${1:-/var/log/auth.log}  # Use provided file or default to /var/log/auth.log

if [[ ! -f "$LOGFILE" ]]; then
  echo "Log file not found: $LOGFILE"
  exit 1
fi

echo "Analyzing log file: $LOGFILE"
echo "---------------------------------------"

# Show top 10 failed SSH login attempts
echo -e "\n🔐 Top 10 Failed Login IPs:"
grep "Failed password" "$LOGFILE" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -10

# Show number of successful root logins (suspicious if high)
echo -e "\n🧨 Successful root logins:"
grep "Accepted" "$LOGFILE" | grep "root" | wc -l

# Show brute force login attempts
echo -e "\n⚠️ Brute Force Detection (IPs with 5+ fails):"
grep "Failed password" "$LOGFILE" | awk '{print $(NF-3)}' | sort | uniq -c | awk '$1 >= 5'

echo -e "\n✅ Analysis Complete."
