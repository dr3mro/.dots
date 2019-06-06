#!/bin/bash 
BAT0=$(awk -v OFMT='%.1f' '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now)
BAT1=$(awk -v OFMT='%.1f' '{print $1*10^-6}' /sys/class/power_supply/BAT1/power_now)
STAT0=$(cat /sys/class/power_supply/BAT0/status)
STAT1=$(cat /sys/class/power_supply/BAT1/status)

if [ $STAT0 = "Discharging" ] || [ $STAT1 = "Discharging" ];then
    echo "-"$(echo $BAT0 + $BAT1 | bc)"W"
elif [ $STAT0 = "Charging" ] || [ $STAT1 = "Charging" ];then
    echo "+"$(echo $BAT0 + $BAT1 | bc)"W"
else
    echo ""
fi
