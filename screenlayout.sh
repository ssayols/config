#!/bin/sh

# NIU with small 19" external + laptop + docking station
if $(xrandr | grep -q "^eDP1 connected") && $(xrandr | grep -q "^DP2-1 connected .*1440x900"); then
  xrandr --output DP2-1 --primary --mode 1440x900 --pos 0x0 --rotate normal --output eDP1 --mode 1920x1080 --pos 1440x0 --rotate normal
# IMB with 24" external + laptop
# HDMI1 connected 1920x1200+0+0 (normal left inverted right x axis y axis) 520mm x 320mm
elif $(xrandr | grep -q "^eDP1 connected") && $(xrandr | grep -q "^HDMI1 connected .*1920x1200"); then
  xrandr --output HDMI1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal
# home with 35" external + laptop + docking station
elif $(xrandr | grep -q "^eDP1 connected") && $(xrandr | grep -q "^DP2-1 connected .*3440x1440"); then
  xrandr --output DP2-1 --primary --mode 3440x1440 --refresh 100 --pos 0x0 --rotate normal --output eDP1 --off
# only laptop: redefine dpi size for high dpi (ubuntu defaults to 96)
elif $(xrandr | grep -q "^eDP1 connected"); then
  xrandr --output eDP1 #--dpi 166
fi
