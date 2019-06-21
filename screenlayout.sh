#!/bin/sh
xrandr --output eDP-1 --dpi 166
if $(xrandr | grep -q "^eDP-1 connected primary 1920x1080") && $(xrandr | grep -q "^DP-1 connected 1440x900"); then
  xrandr --output DP-1 --primary --mode 1440x900 --pos 0x0 --rotate normal --output eDP-1 --mode 1920x1080 --pos 1440x0 --rotate normal
fi
