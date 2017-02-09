#!/bin/sh
if $(xrandr | grep -q "HDMI3 connected") && $(xrandr | grep -q "VGA1 connected"); then
    xrandr --output VIRTUAL1 --off --output DP3 --off --output DP2 --off --output DP1 --off --output HDMI3 --mode 1920x1200 --pos 0x0 --rotate left --output HDMI2 --off --output HDMI1 --off --output LVDS1 --off --output VGA1 --primary --mode 1920x1200 --pos 1200x304 --rotate normal
fi
