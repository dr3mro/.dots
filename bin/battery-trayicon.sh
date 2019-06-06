#!/bin/bash
# battery-status.sh
# Script to show battery status in dual battery Thinkpads 
# Lisence  GPL 3
# Setting Icons
#set -x

BATICON_00_010=""
BATICON_11_024=""
BATICON_25_049=""
BATICON_50_074=""
BATICON_75_100=""
 
CHARGEICON=""
PLUGICON=""
DISCHARGEICON=" "

BAT0ENERGYNOW=`cat /sys/class/power_supply/BAT0/energy_now`
BAT0ENERGYFULL=`cat /sys/class/power_supply/BAT0/energy_full`
BAT1ENERGYNOW=`cat /sys/class/power_supply/BAT1/energy_now`
BAT1ENERGYFULL=`cat /sys/class/power_supply/BAT1/energy_full`

TOTALENERGYNOW=`echo "$BAT0ENERGYNOW + $BAT1ENERGYNOW" | bc`
TOTALENERGYFULL=`echo "$BAT0ENERGYFULL + $BAT1ENERGYFULL" | bc`

TOTALPERCENTAGE=`echo "$TOTALENERGYNOW * 100 / $TOTALENERGYFULL" | bc`

BAT0statusPath="/sys/class/power_supply/BAT0/status"
BAT1statusPath="/sys/class/power_supply/BAT1/status"

BAT0_STATUS=`cat $BAT0statusPath | sed 's/Unknown/Idle/'`
BAT1_STATUS=`cat $BAT1statusPath | sed 's/Unknown/Idle/'`

if [ $TOTALPERCENTAGE -le 10 ] ;then
    BATICON=$BATICON_00_010
elif [ $TOTALPERCENTAGE -le 24 ] ;then 
    BATICON=$BATICON_11_024
elif [ $TOTALPERCENTAGE -le 49 ] ;then 
    BATICON=$BATICON_25_049
elif [ $TOTALPERCENTAGE  -le 74 ] ;then 
    BATICON=$BATICON_50_074
elif [ $TOTALPERCENTAGE  -le 100 ] ;then 
    BATICON=$BATICON_75_100
fi

if [ $BAT0_STATUS = "Discharging" ] || [ $BAT1_STATUS = "Discharging" ];then
    STATUSICON=$DISCHARGEICON
elif [ $BAT0_STATUS = "Charging" ] || [ $BAT1_STATUS = "Charging" ];then
    STATUSICON=$CHARGEICON
else
    STATUSICON=$PLUGICON
fi




echo $STATUSICON $BATICON $TOTALPERCENTAGE%
