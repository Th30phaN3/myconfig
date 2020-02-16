#!/bin/bash
#
# Show all xcolors combinations.
# Each line is the color code of one foreground color,
# out of 17 (default + 16 escapes), followed by a test use
# of that color on all nine background colors (default + 8 escapes).

T='c0l'

echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";

for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m';
  do FG=${FGs// /}
  echo -en " $FGs \033[$FG  $T  "
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
  done
  echo;
done
echo



# Alternative script

# Background
#for clbg in {40..47} {100..107} 49 ; do
#  # Foreground
#  for clfg in {30..37} {90..97} 39 ; do
#    # Formatting
#    for attr in 0 1 2 4 5 7 ; do
#      echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
#    done
#    echo
#  done
#done
