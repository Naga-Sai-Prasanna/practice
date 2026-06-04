#!/bin/bash

source ./common.sh
app_name=shipping
MYSQL_HOST=mysql.prasanna.fun

check_root
app_setup
java_setup

systemd_setup




dnf install mysql -y 
VALIDATE $? "Client installation"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql  | tee -a $LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql    | tee -a $LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql | tee -a $LOG_FILE
    VALIDATE $? "load  data"

else
   echo -e "data is loaded......$Y SKIPPING $N" | tee -a $LOG_FILE
fi 



app_restart
print_total_time

