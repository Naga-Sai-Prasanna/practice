#!/bin/bash
USERID=$(id -u)
LOG_FOLDER="/var/log/shell-script"
LOG_FILE="/LOG_FOLDER/$0.log"

mkdir -p $LOGS_FOLDER

if [ $USERID -ne 0 ]; then
  echo "please run the script with root access"
  exit 1
fi  



VALIDATE(){
   if [ $1 -ne 0 ]; then
    echo "$2 ....failure"
    exit 1
   else
    echo "$2...sucees" 
   fi
}    

dnf install mysql -y &>> $L0G_FILE
VALIDATE $? "installing mysql" 







  