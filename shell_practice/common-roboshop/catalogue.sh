#!/bin/bash

source ./common.sh
app_name=catalogue
check_root
app_setup
nodejs_setup
systemd_setup






cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "COPYING REPO"


dnf install mongodb-mongosh -y
VALIDATE $? "Client installation"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

    if [ $INDEX -le 0 ]; then
        mongosh --host $MONGODB_HOST </app/db/master-data.js
        VALIDATE $? "loading products"
    else
       echo -e "$(date "+%Y-%m-%d %H:%M:%S") | products are already loaded.....$Y skipping $N"
    fi

app_restart
print_total_time








