#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script-backup.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # 14 days is the default value, if user is not supplied.if supplied then 3.


if [ $USERID -ne 0 ]; then
  echo -e "$R Please run the script with root access $N"
  exit
fi

mkdir -p $LOGS_FOLDER

USAGE(){
    echo -e "$R sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>[default 14 days] $N"
    exit 1
}

if [ $# -lt 2 ]; then
   USAGE
fi

if [ -d $SOURCE_DIR ]; then 
  echo -e "$R $SOURCE_DIR does not exist $N"
  exit 1
fi  

if [ -d $SOURCE_DIR ]; then 
  echo -e "$R $DEST_DIR does not exist $N"
  exit 1
fi  

