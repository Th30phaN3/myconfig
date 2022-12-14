#!/bin/bash
#
# Check status of every urls contained in the specified file ($1).

while read URL
do
  if [[ "$URL" =~ ^http ]]; then
    URLSTATUS=$(curl -o /dev/null --silent --head -H 'Cache-Control: no-cache' --write-out '%{http_code}   %{redirect_url}' "$URL")
    echo "$URL     $URLSTATUS" >> url_status.txt
  fi
done < "$1"
