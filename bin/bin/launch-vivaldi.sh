#!/bin/bash
#
# Launch Vivaldi with custom options.

# --start-in-incognito  : Starts the shell with the profile in incognito mode.
# --timeout=<number>    : Issues a stop after the specified number of milliseconds. Cancels all navigation and causes the DOMContentLoaded event to fire.

# TODO : since vivaldi version 5.4.2753.40, the first launch fails (something to do with wayland ?) ! Works with the option "use-gl=desktop" ?

# https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome
/usr/bin/vivaldi --use-gl=desktop --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" --cast-app-background-color="ff2e2e2e" --default-background-color="ff2e2e2e" --disable-breakpad --disable-speech-api --allow-insecure-localhost
