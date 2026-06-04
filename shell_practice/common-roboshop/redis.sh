#!/bin/bash


dnf module disable redis -y
VALIDATE $? "disabling redis"

dnf module enable redis:7 -y
VALIDATE $? "enabling redis"

dnf install redis -y
VALIDATE $? "installation of redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e  '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "allowing remote connections" 


systemctl enable redis  &>> $LOGS_FILE
systemctl start redis
VALIDATE $? "enable and start of the redis" | tee -a  $LOGS_FILE

