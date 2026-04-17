#!/bin/bash
USERID=$(id -u)

if [ $USERID -ne 0 ]; then
 echo "please run the script with root access"
 exit 1
fi

VALIDATE(){

if [ $1 -ne 0 ]; then
   echo "$2 failure"
else 
  echo "$2 success"
fi

}


for app in $@
do
 dnf install $app -y 
 VALIDATE $? "installing $app is success" 
done