#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./check_stream.sh URL [aframes]"
    exit 1
fi

if [ -z "$2" ]; then aframes=500; else aframes=$2; fi

# download a snippet of the livestream
ffmpeg -loglevel quiet -y -i $1 -aframes $aframes /tmp/livesample.mp3

# check to see if the snippet contains 3 seconds of silence
check=$(ffmpeg -i /tmp/livesample.mp3 -af silencedetect=n=-25dB:d=3 -f null - 2>&1 | grep -Eo "silence_(start|end)" | tail -n1 | wc -l | sed 's/^ *//')

if [[ $check -eq 1 ]]; then
    echo "CRITICAL - Substantial silence detected in stream"
else
    echo "OK - No substantial silence detected in stream"
fi


rm /tmp/livesample.mp3
exit 0

