#!/bin/sh
#
# Script used for creating mosaic-like image to preview video content

mkdir -pv Thumbnails
for f in *.*; do vcsi $f -t -w 1000 -g 3x5 -f png -o Thumbnails/$f.png; done