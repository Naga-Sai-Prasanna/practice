#!/bin/bash
source ./common.sh
app_name=user
MYSQL_HOST=mysql.prasanna.fun
check_root



dnf install mysql-server -y
VALIDATE $? "mysql installation"

systemctl enable mysqld
VALIDATE $? "enabling the mysql service"

systemctl start mysqld 

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set root pass"

print_total_time