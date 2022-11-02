#!/usr/bin/env bash

nm-applet &
systemctl --user start ssh-agent
xset r rate 200 60
xrandr --output DisplayPort-0 --auto --left-of HDMI-A-0
