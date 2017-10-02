#!/bin/bash

# Verify cli argument
if [ "$#" -eq 0 ]; then
	echo "use --help flag to get the usage info"
	exit 2 
elif [ "$1" == "--help" ]; then
	echo "usage: encrypt.sh <filename>"
fi

F_NAME=$1
ENC_KEY=$ENCRYPTION_KEY

# Check if file exists
if [ ! -f "$F_NAME" ]; then
	echo "$F_NAME doesn't exist"
	exit 1
fi

# Check encryption key/request one from user
if [ -z "$ENC_KEY" ]; then
	echo "Please enter encryption password:"
	read ENC_KEY
fi

# Encrypt the file
openssl enc -e -aes256 -in "$F_NAME" -out "$F_NAME.enc" -pass pass:$ENC_KEY
echo "Encrypted file saved at $F_NAME.enc"
exit 0
