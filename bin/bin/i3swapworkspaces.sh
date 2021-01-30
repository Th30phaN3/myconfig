#!/bin/bash
#
# Swap workspaces by detecting the currently active workspace
# on each monitor and then moves that workspace to the other monitor.

IFS=:
i3-msg -t get_outputs | jq -r '.[]|"\(.name):\(.current_workspace)"' | grep -v '^null:null$' | \
while read -r name current_workspace; do
  i3-msg workspace "${current_workspace}"
  i3-msg move workspace to output right
done
