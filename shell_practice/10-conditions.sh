#!/bin/bash

NUMBER=$1
if [ $NUMBER  -gt 20 ]; then
  echo " the $NUMBER is greater than 20"
elif [ $NUMBER -eq 20 ]; then
    echo "the $NUMBER is equal 20"
else 
   echo "the $NUMBER is less than 20"
fi  