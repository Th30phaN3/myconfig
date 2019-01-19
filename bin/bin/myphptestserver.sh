#!/bin/sh

#Start a local test server in php with random port

PORT=$(($RANDOM%6000+2001))
echo Starting PHP test server on port $PORT...
php -S 127.0.0.1:$PORT