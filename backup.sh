#!/bin/bash

function help_message {
	echo "usage: $0 [OPTION]... [OUTPUTFILE] [INPUTFILES]..."
	echo "	-c		compress archive"
	echo "	-e		encrypt archive"
	echo "	--help		this help message"
	exit 0
}

function check_last_status {
	if [ $? -ne 0 ]; then
		echo "Failed"
		exit 2
	fi

	echo "Done"
}

if [ $# -eq 0 ]; then
	help_message
elif [ "$1" == "--help" ]; then
	help_message
fi

COMPRESS=0
ENCRYPT=0
ARG_OFFSET=1

if [ "$1" == "-c" ] || [ "$2" == "-c" ]; then
	COMPRESS=1
	ARG_OFFSET=$((ARG_OFFSET + 1))
fi

if [ "$1" == "-e" ] || [ "$2" == "-e" ]; then
	ENCRYPT=1
	ARG_OFFSET=$((ARG_OFFSET + 1))
fi

OUTPUT_FILE=${@:$ARG_OFFSET:1}
ARG_OFFSET=$((ARG_OFFSET + 1))
INPUT_FILES=${@:$ARG_OFFSET}


# Let's encrypt those files
echo "Crating archive"
tar -c -f "$OUTPUT_FILE" $INPUT_FILES
check_last_status

if [ $COMPRESS -eq 1 ]; then
	echo "Compressing archive"
	gzip $OUTPUT_FILE
	check_last_status
	OUTPUT_FILE=$OUTPUT_FILE.gz
fi

if [ $ENCRYPT -eq 1]; then
	echo "Encrypting archive"
	./encrypt $OUTPUT_FILE
	check_last_status
	rm $OUTPUT_FILE
fi

exit 0
