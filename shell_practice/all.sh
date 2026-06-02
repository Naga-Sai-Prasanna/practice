#!/bin/bash



# USERID=$(id -u)
# LOG_FOLDER="/var/log/shell-script"
# LOG_FILE="/var/log/shell-script/$0.log"



# if [ $USERID -ne 0 ]; then
#   echo "please run the script with root access"
#   exit 1
# fi  

# mkdir -p $LOG_FOLDER

# VALIDATE(){
#    if [ $1 -ne 0 ]; then
#     echo "$2 ....failure" | tee -a $LOG_FILE
#     exit 1
#    else
#     echo "$2...sucees" | tee -a $LOG_FILE
#    fi
# }    

# dnf install nodejs -y &>> $LOG_FILE
# VALIDATE $? "installing nodejs" 


#loops

# for i in {1..20}
# do
#    echo $i
# done



USERID=$(id -u)
LOG_FOLDER="/var/log/shell-script"
LOG_FILE="/var/log/shell-script/$0.log"



if [ $USERID -ne 0 ]; then
  echo "please run the script with root access"
  exit 1
fi  

mkdir -p $LOG_FOLDER

VALIDATE(){
   if [ $1 -ne 0 ]; then
    echo "$2 ....failure" | tee -a $LOG_FILE
    exit 1
   else
    echo "$2...sucees" | tee -a $LOG_FILE
   fi
}    

for package in $@
do 
  dnf install $package -y
  VALIDATE $? "$package success"
done  



  