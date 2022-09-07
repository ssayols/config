#!/bin/sh

# home with 35" external (right, primary, set to --auto refresh (60hz) instead of --refresh 100) + laptop (left) + docking station
if $(xrandr | grep -q "^eDP1 connected") && $(xrandr | grep -q "^DP2-1 connected"); then
  DP2_res=$(xrandr | grep -A1 "^DP2-1 connected ." | tail -n +2 | sed 's/^\s\+\([0-9x]\+\).\+/\1/')
  xrandr --output DP2-1 --primary --mode $DP2_res --refresh 100 --pos 1920x0 --rotate normal --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal

# laptop only: redefine dpi size for high dpi (ubuntu defaults to 96, auto should set it to something ~166dpi)
elif $(xrandr | grep -q "^eDP1 connected"); then
  xrandr --output eDP1 # --auto --dpi 166
fi
