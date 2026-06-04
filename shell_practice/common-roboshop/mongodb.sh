#!/bin/bash

source ./common.sh
check_root



cp mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGS_FILE
VALIDATE $? "copying mongo repo" | tee -a  $LOGS_FILE

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "mongodb installation" | tee -a  $LOGS_FILE

systemctl enable mongod  &>> $LOGS_FILE
systemctl start mongod
VALIDATE $? "enable and start of the mongodb" | tee -a  $LOGS_FILE

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connections" | tee -a  $LOGS_FILE

systemctl restart mongod
VALIDATE $? "restarted mongodb" | tee -a  $LOGS_FILE


print_total_time
