#!/bin/bash
#
# This script can save each i3 workspace layout in a temporary directory.
# It can also load those layouts and call each command attributed to a window.
# It behave as a "session restore" feature for i3.
# It is usually called with -[s]ave when quitting i3 and -[l]oad when starting i3.
# ! THIS SCRIPT IS A WORKAROUND, IT IS LIMITED AND CAN BE EASILY BROKEN !

# Directory where temporary workspaces are stored
WK_DIR="$HOME/.cache/i3/wk"

while getopts ":sl" option; do
 case "${option}" in
 s) if [ -n "$LOAD_WK" ]; then
      echo "Error: only one option (save or load) is supported"
      exit
    fi
    SAVE_WK="y";;
 l) if [ -n "$SAVE_WK" ]; then
      echo "Error: only one option (save or load) is supported"
      exit
    fi
    LOAD_WK="y";;
 esac
done
shift $((OPTIND -1))

if [ "$SAVE_WK" == "y" ]; then
  \rm "$WK_DIR/*" 2> /dev/null
  x=1
  while [ $x -le 10 ]
  do
    # Each workspace is saved in i3 cache with its number
    WK_FILE="${WK_DIR}/wk${x}.json"
    i3-save-tree --workspace "$x" > "$WK_FILE"
    # Remove vim markup
    sed -i '1d' "$WK_FILE"
    if [ -s "$WK_FILE" ]
      then
        # Decomment necessary lines to allow swallowing
        sed -i 's#// "class"#"class"#g; s#// "instance"#"instance"#g; s#// \("title": ".*"\)#\1#g' $WK_FILE
        # Remove transient_for and window_role properties
        sed -i '/\/\/\ \"transient_for\"/d; /\/\/\ \"window_role\"/d' $WK_FILE
        # If the container isn't a terminal, remove title property
        IFS_BAK=${IFS}
        IFS=$'\n'
        TORM=($(grep '\"title\":' $WK_FILE | grep -v '\"title\":\ \"\^\(.*\\\\-\\\\>.*\|pulsemixer\|newsboat\|htop\|ncmpcpp\|ranger\|weechat\)\$\"' | sed 's/^ \+//g'))
        IFS=${IFS_BAK}
        for i in "${TORM[@]}"
        do
          # Add necessary escape characters
          CLEAN=$(echo $i | sed 's/\\/\\\\/g; s/\//\\\//g; s/\"/\\\"/g; s/\[/\\\[/g; s/\]/\\\]/g; s/\ /\\\ /g; s/\^/\\\^/g; s/\$/\\\$/g')
          sed -i '/'"${CLEAN}"'/d' $WK_FILE
          COMMA=$(pcregrep -M '\$\",\n +}' $WK_FILE | tr -d '\n' | sed 's/ \+/ /g; s/}//g; s/^ //g; s/ $//g')
          CCLEAN=$(echo $COMMA | sed 's/\\/\\\\/g; s/\//\\\//g; s/\"/\\\"/g; s/\[/\\\[/g; s/\]/\\\]/g; s/\ /\\\ /g; s/\^/\\\^/g; s/\$/\\\$/g')
          # Remove comma from instance line to correctly format json
          sed -i "/${CCLEAN}/s/,//g" $WK_FILE
        done
      else
        # No windows in workspace -> no need to save it
        \rm "$WK_FILE" 2> /dev/null
    fi
    ((x++))
  done
fi

if [ "$LOAD_WK" == "y" ] && [ ! -z "$(ls -A $WK_DIR)" ]; then
  # Declare associative array corresponding to workspaces names
  declare -A WK_NAMES=([1]="1:I" [2]="2:II" [3]="3:III" [4]="4:IV" [5]="5:V" [6]="6:VI" [7]="7:VII" [8]="8:VIII" [9]="9:IX" [10]="10:X")
  for f in $WK_DIR/*.json; do
    WK_NB=$(basename $f | sed 's/[^0-9]*//g')
    NB_WD=$(grep -c '"swallows"' $f)
    # Keep original Internal Field Separator setting
    IFS_BAK=${IFS}
    IFS=$'\n'
    WD_NAMES=($(grep '"name"' $f | sed 's#\\##g; s#"name": "##g; s#",##g; s/ \+/ /g; s/^ //g'))
    WD_CLASSES=($(grep '"class"' $f | sed 's#\\##g; s#"class": "^##g; s#$",##g; s/ \+/ /g; s/^ //g'))
    WD_INSTANCES=($(grep '"instance"' $f | sed 's#\\##g; s#"instance": "^##g; s#$",\?##g; s/ \+/ /g; s/^ //g'))
    WD_TITLES=($(grep '"title"' $f | sed 's#.*"title": "^\(.*\)$",\?#\1#g; s#\\##g'))
    # Set IFS back to normal
    IFS=${IFS_BAK}
    # Change to workspace and apply layout
    i3-msg "workspace number ${WK_NAMES[${WK_NB}]}; append_layout $WK_DIR/wk${WK_NB}.json"
    i=0
    j=0
    while [ $i -lt $NB_WD ]
    do
      case "${WD_CLASSES[$i]}" in
        # If this is a terminal, execute either :
        # - a single program running in the term
        # - term with last path
        UXTerm) XPATH=$(echo "${WD_NAMES[$i]}" | sed 's/ ->.*//')
                XAPP=$(echo "${WD_NAMES[$i]}" | sed 's/.*-> //')
                if [ "$XPATH" == "$XAPP" ]
                then # Single term instance with program inside
                  i3-msg "exec --no-startup-id ${TERMINAL} -title '${XAPP}' -e '${XAPP}'"
                else # Normal term
                  # "title" only present for term windows -> j can be different from i
                  i3-msg "exec --no-startup-id ${TERMINAL} -title '${WD_TITLES[$j]}' -e 'cd ${XPATH} && /bin/bash'"
                fi
                ((j++));;
        # If this is a jetbrains IDE, execute corresponding name
        jetbrains-*) IDE=$(echo "${WD_CLASSES[$i]}" | sed 's/.*-//')
        	         case "${IDE}" in
                       idea) i3-msg "exec --no-startup-id intellijidea";;
        	           phpstorm) i3-msg "exec --no-startup-id phpstorm";;
        	           studio) i3-msg "exec --no-startup-id android-studio'";;
        	         esac;;
        # VS Code
        Code) i3-msg "exec --no-startup-id vscode";;
        # Need to launch Tor Browser from its home
        Tor\ Browser) i3-msg "exec --no-startup-id ${TERMINAL} -e 'cd $HOME/app/tor-browser_en-US && ./start-tor-browser.desktop'";;
        #Microsoft Teams
        Microsoft\ Teams\ -\ Preview) i3-msg "exec --no-startup-id teams";;
        # Firefox
        Firefox) i3-msg "exec --no-startup-id firefox-bin";;
        # Vivaldi
        Vivaldi-stable) i3-msg "exec --no-startup-id launch-vivaldi.sh";;
        # Else execute instance
        *) i3-msg "exec --no-startup-id '${WD_INSTANCES[$i]}'";;
      esac
      ((i++))
    done
  done
fi
