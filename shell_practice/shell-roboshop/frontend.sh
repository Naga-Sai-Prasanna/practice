#!/bin/bash
USERID=$(id -u)
LOGS_FOLDER="/var/log/robpshop"
LOGS_FILE="/$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.prasanna.fun
MYSQL_HOST=mysql.prasanna.fun

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


dnf module disable nginx -y
VALIDATE $? "disable the nginx"

dnf module enable nginx:1.24 -y
VALIDATE $? "enable the version"

dnf install nginx -y
VALIDATE $? "install the nginx"

systemctl enable nginx 
VALIDATE $? "enable the nginx"

systemctl start nginx 
VALIDATE $? "start the nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove the existing content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "download the app code"

cd /usr/share/nginx/html 
VALIDATE $? "going to html location"

unzip /tmp/frontend.zip
VALIDATE $? "unzip the app code"

cp nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying the config"

systemctl restart nginx 
VALIDATE $? "restart the app"
