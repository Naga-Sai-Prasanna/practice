#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-script"
LOGS_FILE="/var/log/shell-script-backup.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
# user should pass source and dest dir and default 14 days but user can ovveride
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # 14 days is the default value, if user is not supplied.if supplied then 3.


log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOGS_FILE
}


# verify the root user

if [ $USERID -ne 0 ]; then
  echo -e "$R Please run the script with root access $N"
  exit
fi

mkdir -p $LOGS_FOLDER

USAGE(){
    log "$R USAGE:: sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>[default 14 days] $N"
    exit 1
}
if [ $# -lt 2 ]; then
   USAGE
fi



# verify the dir

if [ ! -d $SOURCE_DIR ]; then 
  log -e "$R source directory: $SOURCE_DIR does not exist $N"
  exit 1
fi  

if [ ! -d $DEST_DIR ]; then 
  log -e "$R destination directory: $DEST_DIR does not exist $N"
  exit 1
fi  

## find the files

FILES=$(find $SOURCE_DIR -name "*log" -type f -mtime +$DAYS)

log "Backup started"
log "Source Directory: $SOURCE_DIR"
log "Destination Directory: $DEST_DIR"
log "Days: $DAYS"


### check varibales is empty or not if it is there archive them 

if [ -z "${FILES}" ]; then
  log "No files to archieve ... $Y Skipping $N"
else
   # app-logs-$timestamp.zip
   log "Files found to archieve: $FILES"
   TIMESTAMP=$(date +%F-%H-%M-%S)
   ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.tar.gz"
   log "Archieve name: $ZIP_FILE_NAME"
   tar -zcvf $ZIP_FILE_NAME $(find $SOURCE_DIR -name "*log" -type f -mtime +$DAYS) 

   # check archive is success or not
   if [ -f $ZIP_FILE_NAME ]; then
    log "archival is ...$G SUCCESS $N"
    #if success then delte from source dir
    while IFS= read -r filepath
    do
    # processing each line
    log "Deleting file: $filepath"
    rm -f $filepath
    log "deleted the file: $filepath"
    done <<< "$FILES"

   else
    log "archival is ...$R FAILURE $N"
    exit 1

   fi  

fi


# USERID=$(id -u)
# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# N="\e[0m"

# LOG_FOLDER="/var/log/shell"
# LOG_FILE="$LOG_FOLDER/backup.log"
# SOURCE_DIR=$1
# DEST_DIR=$2
# DAYS=${3:-14}

#root user or not
# source dir and destination available or not
# find olde rtahn 14 days file
# if avialble archive them 
#then deelete

# if [ $USERID -ne 0 ]; then
#    echo -e " $R please run with root access $N"
#    exit 1
# fi

# log(){
#     echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOG_FILE
# }
# USAGE(){
#     log  "$R Usage: sudo backup <SOURCE_DIR> <DEST_DIR> DAYS[default 14 days] $N"
#     exit 1
#}

# if [ $# -lt 2 ]; then
#  USAGE
# fi

# if [ ! -d $SOURCE_DIR ]; then
#   log  "source dir is not available"
# fi


# if [ ! -d $DEST_DIR ]; then
#   log  "dest dir is not available"
# fi
 

# FILES=$(find $SOURCE_DIR -type f -mtime +$DAYS) 

# if [ -z "${FILES}" ]; then
#   log "file is empty ... $Y SKIPPING $N"
# else
#   log  "files are ready to archieve: $FILES"
#   TIMESTAMP=$(date +%F-%H-%M-%S)
#   ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.tar.gz"
#   tar -zcvf $ZIP_FILE_NAME $(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)


#   if [ -f $ZIP_FILE_NAME ]; then
#    log "archieval is .. $G success $N"
#    while IFS= read -r filepath
#    do
#     log "deleting files: $filepath"
#     rm -f $filepath
#     log  "deleted the files: $filepath" 
#    done <<< "$FILES"

#    else
#     log  "archivela is  ...$R failure $N"

#    fi
# fi   
