#!/bin/bash
#
# Start mpDris2 then mpd to support MPRIS.

mpDris2 &> /dev/null &
sleep 1
mpd &
