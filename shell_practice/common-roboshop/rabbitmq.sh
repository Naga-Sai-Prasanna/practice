#!/bin/bash
source ./common.sh
app_name=rabbitmq
check_root


cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "rabbitmq repo file"

dnf install rabbitmq-server -y
VALIDATE $? "install rabbitmq"


systemctl enable rabbitmq-server

VALIDATE $? "enabling rabbitmq"

systemctl start rabbitmq-server
VALIDATE $? "start rabbitmq"


rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "setting username and pass"

print_total_time