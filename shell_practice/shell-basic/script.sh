#!/bin/bash
cd /home/ec2-user
mkdir -p app-logs
cd app-logs

files=(users.log cart.log shipping.log payment.log)
dates=(2026-05-01 2026-05-02 2026-06-01 2026-06-02)

for i in 0 1 2 3 
do 
 touch -d "${dates[$i]}" "${files[$i]}"
 echo "files are created"
done

