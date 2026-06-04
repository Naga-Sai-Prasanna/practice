#!/bin/bash



USERID=$(id -u)
LOGS_FOLDER="/var/log/robpshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.prasanna.fun
MYSQL_HOST=mysql.prasanna.fun


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


mkdir -p $LOGS_FOLDER

echo  "$(date +"%Y-%m-%d %H:%M:%S") | script executed on: $(date) at $START_TIME" |  tee -a $LOGS_FILE


check_root(){
    if [ $USERID -ne 0 ]; then
      echo -e " $R please run the script with root access $N" | tee -a $LOGS_FILE
      exit 1
    fi

}

VALIDATE(){

    if [ $1 -ne 0 ]; then
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $R $2 ... failure $N" | tee -a $LOGS_FILE
    else 
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $G $2 ... success $N" | tee -a $LOGS_FILE
    fi

}

nodejs_setup(){
    dnf module disable nodejs -y
    VALIDATE $? "disabling nodejs"

    dnf module enable nodejs:20 -y
    VALIDATE $? "enabling nodejs"

    dnf install nodejs -y
    VALIDATE $? "installation of nodejs"

    npm install
    VALIDATE $? "downloading dependencies"
}

java_setup(){

    dnf install maven -y
    VALIDATE $? "installation of maven"

    cd /app

    mvn clean package
    VALIDATE $? "downloading dependencies"

    mv target/shipping-1.0.jar shipping.jar 
    VALIDATE $? "renaming"
}

python_setup(){

    dnf install python3 gcc python3-devel -y
    VALIDATE $? "installation of python"
    
    cd /app
    pip3 install -r requirements.txt
    VALIDATE $? "downloading dependencies"
}


app_setup(){

    id roboshop &>> $LOGS_FILE
        if [ $? -ne 0 ]; then
        echo "adding user"
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "useradding"
    else
        echo -e  "user is already existed ....$Y SKIPPING $N"
    fi  

    mkdir -p /app
    VALIDATE $? "creating app dir"


    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
    VALIDATE $? "downloading nodejs"

    cd /app 
    VALIDATE $? "Moving to app dir"

    rm -rf /app/*
    VALIDATE $? "removing the data"

    unzip /tmp/$app_name.zip
    VALIDATE $? "unzip the code"
    
}

systemd_setup(){
    
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service

    systemctl daemon-reload
    VALIDATE $? "reload"

    systemctl enable $app_name 
    systemctl start $app_name 
    VALIDATE $? "enabling and start"
}


app_restart(){
    systemctl restart $app_name
    VALIDATE $? "Restaring $app_name"

}
print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $G script completed on: $(date) at $TOTAL_TIME seconds $N" |  tee -a $LOGS_FILE
}