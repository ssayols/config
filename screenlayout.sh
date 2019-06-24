#!/bin/sh

# NIU with small 19" external + laptop
if $(xrandr | grep -q "^eDP-1 connected") && $(xrandr | grep -q "^DP-1 connected .*1440x900"); then
  xrandr --output DP-1 --primary --mode 1440x900 --pos 0x0 --rotate normal --output eDP-1 --mode 1920x1080 --pos 1440x0 --rotate normal
# home with 35" external + laptop
elif $(xrandr | grep -q "^eDP-1 connected") && $(xrandr | grep -q "^DP-2-1 connected .*3440x1440"); then
  xrandr --output DP-2-1 --primary --mode 3440x1440 --refresh 100 --pos 0x0 --rotate normal --output eDP-1 --off
# only laptop: redefine dpi size for high dpi (ubuntu defaults to 96)
elif $(xrandr | grep -q "^eDP-1 connected"); then
  xrandr --output eDP-1 --dpi 166
fi
