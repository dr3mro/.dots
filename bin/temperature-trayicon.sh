#!/bin/bash 
RAWCPUTEMP=`cat /sys/class/thermal/thermal_zone0/temp | bc`
T_CPU=`echo "$RAWCPUTEMP / 1000" | bc`

white='%{F#A9A9A9}'
blue='%{F#87CEFA}'
green='%{F#ADFF2F}'
yellow='%{F#FFD700}'
red='%{F#FF0000}'

burn=""
ramp0=""
ramp1=""
ramp2=""
ramp3=""
ramp4=""
if [ $T_CPU -le 30 ] ;then 
    ramp=$ramp0
    color=$white
elif [ $T_CPU -le 40 ] ;then 
    ramp=$ramp1
    color=$green
elif [ $T_CPU -le 50 ] ;then 
    ramp=$ramp2
    color=$blue
elif [ $T_CPU -le 60 ] ;then 
    ramp=$ramp3
    color=$yellow
elif [ $T_CPU -le 70 ] ;then 
    ramp=$ramp4
    color=$red
elif [ $T_CPU -gt 70 ] ;then 
    ramp=$burn
    color=$red
fi

#echo -e "$color$ramp $white$T_CPU°C"
echo "$color$ramp $white$T_CPU°C"
