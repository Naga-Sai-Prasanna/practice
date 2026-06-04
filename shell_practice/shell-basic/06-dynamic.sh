#!/bin/bash
# time=$(date)
# echo "current $time"

Start=$(date +%s)
echo "script executed at: $Start"
sleep 10 
end=$(date +%s)
echo "script executed at : $end"

totaltime=$(($Start-$end))
echo "totaltime is: $totaltime in sec"