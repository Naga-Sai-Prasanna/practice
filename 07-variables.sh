#!/bin/bash
echo "all args passed to script: $@"
echo "all args passed through script combine: $*"
echo "no.of argumens passed : $#"
echo "first arg : $1"
echo "current user : $USER"
echo "home dir : $home"
echo "name of the scripts : $0"
echo "current dir : $PWD"

echo " pid of the script : $$"
sleep 10 &
echo "background pid : $!"



