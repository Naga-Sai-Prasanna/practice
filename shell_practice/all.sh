#!/bin/bash
USERID=$(id -u)

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

dnf install nginx -y
VALIDATE $? "installing nginx" 







  