#!/bin/bash
#change keyboard layout, from US to ES and back (depending on the active one)
if [ $(setxkbmap -query | awk '/layout/{print $2}') == us ]; then
  setxkbmap es
else
  setxkbmap us
fi
xmodmap ~/.config/i3/mapEscToCaps
