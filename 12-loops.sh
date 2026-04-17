#!/bi/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]; then
 echo "please run the script with root access"
 exit 1
fi

VALIDATE(){

if [ $1 -ne 0 ]; then
   echo "$2.... failure"
else 
  echo "$2.... success"
fi

}


dnf install nginx -y
VALIDATE $? installing nginx

dnf install nodejs -y
VALIDATE $? installing nodejs