#!/bin/sh

wid=$1
class=$2
instance=$3
title=$(xtitle "$wid")

eval $(xwininfo -id $wid | \
    sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
       -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
       -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
       -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )

if [[ $title == "Picture in picture" ]] ;then
    echo state=floating
    echo focus=on
    echo locked=on
    echo border=off
    xdotool windowmove $wid $((1366 - $w)) $((768 - $h))
    xdotool windowactivate $wid
elif [[ $title = "gotop" || $title = "htop" || $title = "floatingTerm"  || $title = "Volume Control" || $title = "nmtuifloat" || $title = "gsimplecal" ]] ;then
    echo state=floating
    echo focus=on
elif [[ $title = "Save screenshot as..." ]] ;then 
    xdotool windowsize $wid 560x400
fi

