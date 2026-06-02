#!/bin/bash

# person1=$1
# person2=$2

# echo "$person1: hi"
# echo  "$person2: hello"

# echo "please enter your username::"
# read user_name
# echo "user name is $user_name"

# echo "please enter your pass::"
# read -s password

# start_time=$(date +%s)

# echo "script executed at:: $start_time"
# sleep 10
# end_time=$(date +%s)


# echo "script ended at:: $end_time"
# total_time=$(($end_time-$start_time))

# echo "script executed in :: $total_time sec"


# number=$1

# if [ $number -gt 20 ]; then
#    echo "the given $number is greater than 20"
# elif [ $number -eq 20 ]; then
#     echo "the given $number is equal to 20" 
# else
#   echo "the given $number is less than 20"  

# # fi  

# USERID=$(id -u)

# if [ $USERID -ne 0 ]; then
#   echo "please run this script with root access"
#   exit 1
# fi

# echo "installing nginx"
# dnf install nginx -y

# if [ $? -ne 0 ]; then
#   echo "installing nginx ... failure"
#   exit 1
# else
#  echo "installing nginx...succeess"
# fi   


USERID=(id -u)

if [ $USERID -ne 0 ]; then
  echo "please run the script with root access"
  exit 1
fi  

VALIDATE(){
   if [ $1 -ne 0 ]; then
 echo "$2 ....failure"
else
  echo "$2...sucees" 
}    

VALIDATE $? "installing nginx" 







  