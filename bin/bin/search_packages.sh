#!/bin/bash
#
# Search https://gpo.zugaina.org for packages
# Official Gentoo tree + overlays are included
# DEPRECATED - Use "eix -R" instead !

# Clean up search term
STERM=$(echo "$1" | tr -s " ")
STERM=${STERM%% }
STERM=${STERM## }
STERM=$(echo "${STERM// /+}")

curl -s "https://gpo.zugaina.org/Search?search=${STERM}" | hxnormalize -x | hxselect -l en -c '#search_results' | sed 's/^ *//;/<a/d;s/<div>//;s|</div>||;s|<h3>||;s|</h3>||' | grep --color -E "${STERM}|$"
