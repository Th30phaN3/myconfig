#!/bin/bash
#
# This script does nothing, it's just an example to show use of aliases in bash scripts.

shopt -s expand_aliases
source "${HOME}"/.bash_aliases

# Print the content of the alias "ll"
echo ${BASH_ALIASES[ll]}

# Use the alias "ll"
ll
