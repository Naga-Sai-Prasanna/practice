#!/bin/bash



USERID=$(id -u)
LOGS_FOLDER="/var/log/robpshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
START_TIME=$(date +%s)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


mkdir -p $LOGS_FOLDER

echo  "$(date +"%Y-%m-%d %H:%M:%S") | script executed on: $(date) at $START_TIME" |  tee -a $LOGS_FILE


check_root(){
    if [ $USERID -ne 0 ]; then
      echo -e " $R please run the script with root access $N" | tee -a $LOGS_FILE
      exit 1
    fi

}

VALIDATE(){

    if [ $1 -ne 0 ]; then
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $R $2 ... failure $N" | tee -a $LOGS_FILE
    else 
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $G $2 ... success $N" | tee -a $LOGS_FILE
    fi

}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $G script completed on: $(date) at $TOTAL_TIME seconds $N" |  tee -a $LOGS_FILE
}