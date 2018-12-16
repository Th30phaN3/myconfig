#!/bin/sh
mode[0]="-b"
mode[1]="-d"
mode[2]="-g"
mode[3]="-p"
mode[4]="-s"
mode[5]="-t"
mode[6]="-w"
mode[7]="-y"

index_mode=$(($RANDOM % 8))

file[0]="default"
file[1]="udder"
file[2]="bong"
file[3]="bud-frogs"
file[4]="cower"
file[5]="dragon"
file[6]="dragon-and-cow"
file[7]="elephant"
file[8]="ghostbusters"
file[9]="kitty"
file[10]="meow"
file[11]="moofasa"
file[12]="moose"
file[13]="mutilated"
file[14]="satanic"
file[15]="sheep"
file[16]="skeleton"
file[17]="small"
file[18]="stegosaurus"
file[19]="supermilker"
file[20]="three-eyes"
file[21]="turkey"
file[22]="turtle"
file[23]="vader"
file[24]="www"
file[25]="default"

index_file=$(($RANDOM % 26))

speech[0]="cowsay"
speech[1]="cowthink"

index_speech=$(($RANDOM % 2))

fortune -a | ${speech[$index_speech]} ${mode[$index_mode]} -f ${file[$index_file]}