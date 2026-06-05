#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MESSAGE=""


log(){
    echo -e "$(date "+%Y-%m-%d %H:%M-%S") | $1" | tee -a $LOGS_FILE
}

DISK_USAGE=$(df -hT | grep -v Filesystem)
USAGE_THRESHOLD=3

while IFS= read -r line
do
 USAGE=(echo $line | awk '{print $6}' | cut -d "%" -f1)
 PARTITION=(echo $line | awk '{print $7}')

 if [ "$USAGE" -ge "$USAGE_THRESHOLD" ]; then
  
    MESSAGE+="High Disk Usage On $PARTITION:$USAGE% \n"
 fi   
done <<< $DISK_USAGE

echo "$MESSAGE"