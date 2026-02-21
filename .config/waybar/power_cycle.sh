#!/bin/bash
CURRENT=$(asusctl profile -p | grep "Active" | grep -oE 'Quiet|Balanced|Performance')

case $CURRENT in
    "Performance")
        asusctl profile -P Quiet
        notify-send "󰾆 Quiet Mode" -t 2000
        ;;
    "Quiet")
        asusctl profile -P Balanced
        notify-send "󰾅 Balanced Mode" -t 2000
        ;;
    *)
        asusctl profile -P Performance
        notify-send "󰓅 Performance Mode" -t 2000
        ;;
esac
