#!/bin/bash
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell"
LOGS_FILE="/var/log/shell/$0.log"

if [ $USERID -ne 0 ]; then
 echo "please run the script with root access" | tee -a $LOGS_FILE
 exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){

if [ $1 -ne 0 ]; then
   echo "$2 ... failure" | tee -a $LOGS_FILE
else 
  echo "$2 ... success" | tee -a $LOGS_FILE
fi

}


for app in $@
do
  dnf list installed $app &>>LOGS_FILE
  if [ $? -ne 0 ]; then
   echo "$app is not installed installing now"
  else
   echo "$app is installed already"  
   exit 1
  fi 
  dnf install $app -y &>>$LOGS_FILE
  VALIDATE $? "$app installation" 
done