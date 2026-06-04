#!/bin/bash
source ./common.sh
app_name=frontend
check_root


dnf module disable nginx -y  &>> $LOGS_FILE
VALIDATE $? "disable the nginx"

dnf module enable nginx:1.24 -y  &>> $LOGS_FILE
VALIDATE $? "enable the version"

dnf install nginx -y  &>> $LOGS_FILE
VALIDATE $? "install the nginx"
 
systemctl enable nginx   &>> $LOGS_FILE
VALIDATE $? "enable the nginx"

systemctl start nginx   &>> $LOGS_FILE
VALIDATE $? "start the nginx"

rm -rf /usr/share/nginx/html/*   &>> $LOGS_FILE
VALIDATE $? "remove the existing content"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
VALIDATE $? "download the app code"

cd /usr/share/nginx/html 
VALIDATE $? "going to html location"

unzip /tmp/$app_name.zip
VALIDATE $? "unzip the app code"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf | tee -a $LOGS_FILE
VALIDATE $? "copying the config"

systemctl restart nginx 
VALIDATE $? "restart the application"

print_total_time

