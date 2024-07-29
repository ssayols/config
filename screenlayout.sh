#!/bin/sh

# home with 35" external (right, primary, set to --auto refresh (60hz) instead of --refresh 100) + laptop (left) + docking station
if $(xrandr | grep -q "^eDP-1 connected") && $(xrandr | grep -q "^DP-2-. connected"); then
  DP2=$(xrandr | grep "^DP-2-. connected ." | sed 's/\sconnected\s.\+//')
  DP2_res=$(xrandr | grep -A1 "^DP-2-. connected ." | tail -n +2 | sed 's/^\s\+\([0-9x]\+\).\+/\1/')
  xrandr --output $DP2 --primary --mode $DP2_res --refresh 100 --pos 1920x0 --rotate normal --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal

# laptop only: redefine dpi size for high dpi (ubuntu defaults to 96, auto should set it to something ~166dpi)
elif $(xrandr | grep -q "^eDP-1 connected"); then
  xrandr --output eDP-1 # --auto --dpi 166
fi
