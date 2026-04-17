#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell"
LOGS_FILE="/var/log/shell/$0.log"



if [ $USERID -ne 0 ]; then
 echo "please run the script with root access"
 exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){

if [ $1 -ne 0 ]; then
   echo "$2 failure"
else 
  echo "$2 success"
fi

}


dnf install nginx -y &>> $LOGS_FILE
VALIDATE $? "installing nginx"


dnf install nodejs -y &>> $LOGS_FILE
VALIDATE $? "installing nodejs"
