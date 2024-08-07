# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout somewhen, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4
#set $mod2 Mod5 
# Mod5 is AltGr, after assigning it with this xmodmap script:
#     clear mod1
#     clear mod5
#     keycode 0x6c = ISO_Level3_Shift NoSymbol ISO_Level3_Shift  NoSymbol
#     add Mod1 = Alt_L Meta_L
#     add Mod5 = ISO_Level3_Shift
#  0x6c is Alt_R. Keycodes can be retrieved with `xev`

##
## Startup programs and keybindings
##
# Rstudio docker container
#exec --no-startup-id podman run --name rstudio -v /home/sergi:/home/sergi -e PASSWORD='  ' -p 8787:8787 rocker/rstudio

# touchpad config
# view devices and device settings with `xinput && xinput list-props "ALP0018:00 044E:121B Touchpad"`
exec xinput set-prop "ALP0018:00 044E:121B Touchpad" "libinput Tapping Enabled" 1
exec xinput set-prop "ALP0018:00 044E:121B Touchpad" "libinput Natural Scrolling Enabled" 1
exec xinput set-prop "ALP0018:00 044E:121B Touchpad" "libinput Middle Emulation Enabled" 1
# disable touchpad when typing (only works with synaptic touchpads)
#exec syndaemon -i 1 -K -d

# Skype, dropbox, slack and teams (set video to 640x480 as Teams doesn't seem to like resolution 1080 pixels)
exec --no-startup-id seadrive-gui
# check changes in default video settings with `v4l2-ctl -d /dev/video0 -V`. All available video modes with `v4l2-ctl -d /dev/video0 --list-formats-ext`
#exec --no-startup-id v4l2-ctl -d /dev/video0 -v width=640,height=480,pixelformat=MJPG
#exec --no-startup-id /opt/google/chrome/google-chrome --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo
#assign [class="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] 1
#for_window [class="crx_cifhbcnohmdccbgoicgdjpfamggdegmo"] floating enable

# screenlayout: set multimonitor setup (first time configuration generated by arandr)
exec --no-startup-id ~/.config/i3/screenlayout.sh
# set the background picture
#exec --no-startup-id feh --bg-center ~/Pictures/Chogori.jpg
exec --no-startup-id xsetroot -solid "#000000"
# disable system bell
exec --no-startup-id set b off

# open applets: network-manager, volume, redshift, gnome clipboard manager
exec --no-startup-id nm-applet
exec --no-startup-id volumeicon
#exec --no-startup-id redshift-gtk   # note: disabled reshift because it produces some flickering
#exec --no-startup-id gpaste-client

# exchange Esc-Caps keys
exec --no-startup-id "sleep 2; xmodmap ~/.config/i3/mapEscToCaps"
# setup US and ES keyboard layouts
exec "setxkbmap -layout us,es"
# set esc to caps again
bindsym --release Mod1+Escape exec --no-startup-id "sleep 1; xmodmap ~/.config/i3/mapEscToCaps"
# switch keyboard layout with Alt+Scape
bindsym Mod1+space exec ~/.config/i3/changeKbdLayout.sh
exec "setxkbmap -option 'grp:alt_shift_toggle'"

# open Neovim with a shortcut
bindsym $mod+Shift+Return exec xterm -title "Neovim - i3" -geometry 80x24 -fa 'Monospace' -fs 11 -e nvim
for_window [title="Neovim - i3" class="XTerm"] floating enable

# open ranger or nautilus with a shortcut
#bindsym $mod+n exec gnome-terminal --title="ranger" -x ranger
bindsym $mod+e exec "nautilus --no-desktop&"
for_window [class="Nautilus"] floating enable
for_window [class="Gnome-calculator"] floating enable

# take screenshot (full desktop, current window, selection
#bindsym --release Print exec scrot -e 'mv $f ~/Pictures'
#bindsym --release Shift+Print exec scrot -ue 'mv $f ~/Pictures'
#bindsym --release $mod+Print exec scrot -se 'mv $f ~/Pictures'
bindsym --release Print exec --no-startup-id maim --capturebackground --hidecursor --select /home/sergi/Pictures/$(date +"%y%m%d_%H%M%S").png

# control audio keys (with alsa or pulseaudio <-- the latter preferred)
#bindsym XF86AudioRaiseVolume exec "amixer -q sset Master,0 1+ unmute"
#bindsym XF86AudioLowerVolume exec "amixer -q sset Master,0 1- unmute"
#bindsym XF86AudioMute exec "amixer -q sset Master,0 toggle"

# use pulseaudio (pactl). DEFUNCT: see below
#set $sink `pactl list short sinks | grep RUNNING | cut -f1`
#bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume $sink +10%
#bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume $sink -10%
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute $sink toggle
# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# control screen brightness
# sudo find /sys/ -type f -iname '*brightness*'
# Add this to /usr/share/X11/xorg.conf.d/20-intel-brightness.conf
# Section "Device"
#        Identifier      "Card0"
#        Driver          "intel"
#        Option          "Backlight"     "/sys/class/backlight/intel_backlight"
#EndSection
bindsym XF86MonBrightnessUp exec xbacklight -inc 10 # increase screen brightness
bindsym XF86MonBrightnessDown exec xbacklight -dec 10 # decrease screen brightness

# enable/disable screens: $mod+F1 --> force laptop; $mod+F2 --> run screenlayout.sh again
bindsym --release $mod+F1 exec --no-startup-id "for display in $(xrandr | grep -e '\bconnected\b' | cut -f1 -d ' ' | grep -v eDP-1); do xrandr --output $display --off; done; xrandr --output eDP-1 --auto"
bindsym --release $mod+F2 exec --no-startup-id ~/.config/i3/screenlayout.sh

# system menu
set $mode_system System (l)ock, (L)ogout, (s)uspend, (h)ibernate, (r)eboot, (S)hutdown
mode "$mode_system" {
  bindsym l exec --no-startup-id ~/.config/i3/screenlock; mode "default"
  bindsym Shift+l exec "i3-msg exit"
  bindsym s exec --no-startup-id i3lock -c 111111 && systemctl suspend -i; mode "default"
  bindsym h exec --no-startup-id i3lock -c 111111 && systemctl hibernate -i; mode "default"
  bindsym r exec --no-startup-id systemctl reboot
  bindsym Shift+s exec --no-startup-id systemctl poweroff

  # back to normal: Enter or Escape
  bindsym Return mode "default"
  bindsym Escape mode "default"
}
bindsym $mod+Shift+e mode "$mode_system"

# screen lock after 15 min
exec --no-startup-id xautolock -time 15 -locker '~/.config/i3/screenlock'

# Make the currently focused window a scratchpad
bindsym $mod+Shift+minus move scratchpad
# Show the first scratchpad window
bindsym $mod+Shift+equal scratchpad show

#
# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below. ISO 10646 = Unicode
#font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, if you need a lot of unicode glyphs or
# right-to-left text rendering, you should instead use pango for rendering and
# chose a FreeType font, such as:
font pango:DejaVu Sans Mono 9
#font pango:DejaVu Sans Mono, Terminus Bold Semi-Condensed 11
#font pango:DejaVu Sans Mono, Terminus 9
#font pango:Terminus 13px

# Window border style
#---------------------
# normal: border normal, with window title bar
# pixel: border only, no window title bar
# 1pixel: border only, no window title bar
# none: nothing
new_window pixel

## Colors
##---------
# colour of border, background, text, indicator, and child_border
client.focused          #bf616a #2f343f #d8dee8 #bf616a #d8dee8
client.focused_inactive #2f343f #2f343f #d8dee8 #2f343f #2f343f
client.unfocused        #2f343f #2f343f #d8dee8 #2f343f #2f343f
client.urgent           #2f343f #2f343f #d8dee8 #2f343f #2f343f
client.placeholder      #2f343f #2f343f #d8dee8 #2f343f #2f343f
client.background       #2f343f

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec i3-sensible-terminal

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
# bindsym $mod+d exec dmenu_run
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# alternatively, you can use the cursor keys:
#bindsym $mod+Left focus left
#bindsym $mod+Down focus down
#bindsym $mod+Up focus up
#bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# alternatively, you can use the cursor keys:
#bindsym $mod+Shift+Left move left
#bindsym $mod+Shift+Down move down
#bindsym $mod+Shift+Up move up
#bindsym $mod+Shift+Right move right

# split in horizontal orientation
#bindsym $mod+h split h
bindsym $mod+Shift+v split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen

# change container layout (stacked, tabbed, toggle split)
#bindsym $mod+s layout stacking
bindsym $mod+comma layout stacking
#bindsym $mod+w layout tabbed
bindsym $mod+period layout tabbed
#bindsym $mod+e layout toggle split
bindsym $mod+slash layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
# Sergi: controlled through the system menu
#bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym j resize grow height 10 px or 10 ppt
        bindsym k resize shrink height 10 px or 10 ppt
        bindsym l resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
#        bindsym Left resize shrink width 10 px or 10 ppt
#        bindsym Down resize grow height 10 px or 10 ppt
#        bindsym Up resize shrink height 10 px or 10 ppt
#        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status finds out, if available)
bar {
  #status_command i3status
  status_command ~/.config/i3status/i3status.sh
  position bottom

  colors {
    background #2f343f
    statusline #2f343f
    separator #4b5262

    # colour of border, background, and text
    focused_workspace   #2f343f #bf616a #d8dee8
    active_workspace    #2f343f #2f343f #d8dee8
    inactive_workspace  #2f343f #2f343f #d8dee8
    urgent_workspace    #2f343f #ebcb8b #2f343f
  }
} 
