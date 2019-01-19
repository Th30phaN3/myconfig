#!/bin/sh

#Encode clipboard content into a qr code

qrencode -o - -s 1 "$(xclip -out -selection clipboard)" | feh --zoom max -F --force-aliasing --image-bg white -