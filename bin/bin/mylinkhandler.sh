#!/bin/sh

# Feed script a url or file location.
# If an image, it will view in feh,
# if a video or gif, it will view in mpv
# if a music file or pdf, it will download,
# otherwise it opens link in browser.

# Sci-Hub's domain occasionally changes due to shutdowns:
scihub="http://sci-hub.tw/"

# If no url given. Opens browser. For using script as $BROWSER.
[ -z "$1" ] && { "$TRUEBROWSER"; exit; }

case "$1" in
	*mkv|*webm|*mp4|*gif|*youtube.com*|*youtu.be*|*hooktube.com*|*bitchute.com*) setsid mpv -quiet "$1" >/dev/null 2>&1 & ;;
	*png|*jpg|*jpe|*jpeg) setsid feh "$1" >/dev/null 2>&1 & ;;
	*mp3|*flac|*opus|*mp3?source) setsid tsp curl -LO "$1" >/dev/null 2>&1 & ;;
	*springer.com*) setsid curl -sO "$(curl -s "$scihub$*" | grep -Po "(?<=location.href=').+.pdf")" >/dev/null 2>&1 & ;;
	*) if [ -f "$1" ]; then "$TERMINAL" -e "$EDITOR $1" else setsid "$TRUEBROWSER" "$1" >/dev/null 2>&1 & fi ;;
esac