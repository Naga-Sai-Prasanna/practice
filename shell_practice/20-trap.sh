#!/bin/bash

set -e
trap 'echo "there is an error in $LINENO, command: $BASH_COMMAND"' ERR

echo "hi"
echo "hello"
echooo "bye"
