#!/bin/bash
# shell scipt to prepend i3status with more stuff
i3status --config ~/.config/i3status/config | while :
do
  read line
  x=$(setxkbmap -query | awk '/layout/{print $2}') 
  dat="[{ \"full_text\": \"layout: $x\", \"color\":\"#FFFFFF\" },"
  echo "${line/[/$dat}" || exit 1
done
