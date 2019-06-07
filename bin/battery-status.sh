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

#setting Battery sys path
BAT0capacityPath="/sys/class/power_supply/BAT0/capacity"
BAT1capacityPath="/sys/class/power_supply/BAT1/capacity"
BAT0statusPath="/sys/class/power_supply/BAT0/status"
BAT1statusPath="/sys/class/power_supply/BAT1/status"

#get the battey levels & stats
BAT0_CAPACITY=`cat $BAT0capacityPath`
BAT1_CAPACITY=`cat $BAT1capacityPath`
BAT0_STATUS=`cat $BAT0statusPath | sed 's/Unknown/Idle/'`
BAT1_STATUS=`cat $BAT1statusPath | sed 's/Unknown/Idle/'`

if [ $BAT0_CAPACITY -le 10 ] ;then
    BATICON0=$BATICON_00_010
elif [ $BAT0_CAPACITY -le 24 ] ;then 
    BATICON0=$BATICON_11_024
elif [ $BAT0_CAPACITY -le 49 ] ;then 
    BATICON0=$BATICON_25_049
elif [ $BAT0_CAPACITY -le 74 ] ;then 
    BATICON0=$BATICON_50_074
elif [ $BAT0_CAPACITY -le 100 ] ;then 
    BATICON0=$BATICON_75_100
fi


if [ $BAT1_CAPACITY -le 10 ] ;then
    BATICON1=$BATICON_00_010
elif [ $BAT1_CAPACITY -le 24 ] ;then 
    BATICON1=$BATICON_11_024
elif [ $BAT1_CAPACITY -le 49 ] ;then 
    BATICON1=$BATICON_25_049
elif [ $BAT1_CAPACITY -le 74 ] ;then 
    BATICON1=$BATICON_50_074
elif [ $BAT1_CAPACITY -le 100 ] ;then 
    BATICON1=$BATICON_75_100
fi

BAT0ENERGYNOW=`cat /sys/class/power_supply/BAT0/energy_now`
BAT0ENERGYFULL=`cat /sys/class/power_supply/BAT0/energy_full`
BAT1ENERGYNOW=`cat /sys/class/power_supply/BAT1/energy_now`
BAT1ENERGYFULL=`cat /sys/class/power_supply/BAT1/energy_full`

TOTALENERGYNOW=`echo "$BAT0ENERGYNOW + $BAT1ENERGYNOW" | bc`
TOTALENERGYFULL=`echo "$BAT0ENERGYFULL + $BAT1ENERGYFULL" | bc`

POWER0=$(awk -v OFMT='%.1f' '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now)
POWER1=$(awk -v OFMT='%.1f' '{print $1*10^-6}' /sys/class/power_supply/BAT1/power_now)

TOTALPOWER=`echo "$POWER0 + $POWER1" | bc`


if [ $BAT0_STATUS = "Discharging" ] || [ $BAT1_STATUS = "Discharging" ];then
    RATE=`echo $POWER0 + $POWER1 | bc`
    WATTAGE="-$RATE Wh"
    TOTALTIMEINMINUTES=`echo "$TOTALENERGYNOW * 60  / ($RATE * 1000000) " | bc`
    T_hrs=`echo "$TOTALTIMEINMINUTES / 60" | bc`
    T_min=`echo "$TOTALTIMEINMINUTES % 60" | bc`
#    TIMEREMAINING=`echo "Remaining Time $T_hrs:$T_min"`
TIMEREMAINING=`echo "Remaining Time $(printf '%d:%02d' $T_hrs $T_min) h"`

elif [ $BAT0_STATUS = "Charging" ] || [ $BAT1_STATUS = "Charging" ];then
    RATE=`echo "$POWER0 + $POWER1" | bc`
    WATTAGE="+$RATE Wh"
    TOTALTIMEINMINUTES=`echo "($TOTALENERGYFULL - $TOTALENERGYNOW )* 60 / ($RATE * 1000000) " | bc`

    T_hrs=`echo "$TOTALTIMEINMINUTES / 60" | bc`
    T_min=`echo "$TOTALTIMEINMINUTES % 60" | bc`

#    T_hrs=`awk '{printf "%f", $TOTALTIMEINMINUTES / 60}'`
#    T_min=`awk '{printf "%f", $TOTALTIMEINMINUTES % 60}'`
TIMEREMAINING=`echo "Remaining Time $(printf '%d:%02d' $T_hrs $T_min) h"`
fi

if [[ $BAT0_STATUS = "Idle" || $BAT0_STATUS = "Full" ]] ;then
    AT0=""
    WATTAGE0=""
else
    AT0="at"
    WATTAGE0=$WATTAGE
fi

if [[ $BAT1_STATUS = "Idle" || $BAT1_STATUS = "Full" ]] ;then
    AT1=""
    WATTAGE1=""
else
    AT1="at"
    WATTAGE1=$WATTAGE
fi

BATTERYMSG="Battery 0 : $BATICON0 $BAT0_CAPACITY % is $BAT0_STATUS $AT $WATTAGE0
Battery 1 : $BATICON1 $BAT1_CAPACITY % is $BAT1_STATUS $AT1 $WATTAGE1 \n$TIMEREMAINING" 


#Send Notification
notify-send -i 0 "Battery Info" "$BATTERYMSG"

