#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

export LC_ALL=lt_LT.UTF-8
export LANGUAGE=lt_LT.UTF-8
export LANG=lt_LT.UTF-8

mail-notification &
xrdb -merge ~/.Xresources &

#exec ck-launch-session startlxde
exec ssh-agent ck-launch-session dbus-launch --exit-with-session startlxde
