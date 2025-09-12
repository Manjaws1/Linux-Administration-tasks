  GNU nano 7.2                  sys_health.sh                           #!/bin/bash
LOG_FILE="/var/log/sys_health.log"

echo "==== System Health Report: $(date) ====" >> $LOG_FILE
echo "CPU Usage:" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" >> $LOG_FILE
echo "Memory Usage:" >> $LOG_FILE
free -h >> $LOG_FILE
echo "Disk Usage:" >> $LOG_FILE
df -h >> $LOG_FILE
echo -e "\n" >> $LOG_FILE
