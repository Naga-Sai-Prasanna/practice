#!/bin/bash

set -e # this will be checking  for errors if errors it will exit

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell"
LOGS_FILE="/var/log/shell/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


mkdir -p $LOGS_FOLDER

if [ $USERID -ne 0 ]; then
 echo -e " $R please run the script with root access $N" | tee -a $LOGS_FILE
 exit 1
fi


VALIDATE(){

if [ $1 -ne 0 ]; then
   echo -e "$R $2 ... failure $N" | tee -a $LOGS_FILE
else 
  echo -e "$G $2 ... success $N" | tee -a $LOGS_FILE
fi

}


for app in "$@"
do
  dnf list installed $app &>>$LOGS_FILE
  if [ $? -ne 0 ]; then
   echo "$app is not installed, installing now"
  else
   echo -e "$G $app is installed already $N"  
   exit 1
  fi 
  dnf install $app -y &>>$LOGS_FILE
#   VALIDATE $? "$app installation" 
done