#!/bin/sh

# checks network connectivity and reboots if there are problems
# credit here: http://www.raspberrypi.org/phpBB3/viewtopic.php?f=30&t=20149

# place in cron to check every two minutes:
# */2 * * * *    root    /path/to/network_check.sh wlan0 192.168.0.1 /opt/check_lan/stuck.fflg >/dev/null

if [ $# -lt 3 ]
then
    echo "Invalid command line arguments." >&2
    echo "Usage:   network_check.sh <INTERFACE> <IP_TO_CHECK> <FLAG_FILE>" >&2
    echo "Example: network_check.sh wlan0 192.168.0.1 /opt/check_lan/stuck.fflg" >&2
    exit 1
fi

# grab options from command line
INTERFACE=$1
IP_FOR_TEST=$2
FLAG=$3

# probably don't need to change below here
PING_COUNT=1
PING="/bin/ping"
IFUP="/sbin/ifup"
IFDOWN="/sbin/ifdown --force"

# make sure flag dir exists
FLAGDIR=`dirname $FLAG`
if [ ! -d $FLAGDIR ]
then
    logger "creating flag directory: $FLAGDIR"
    sudo mkdir -p $FLAGDIR
fi

# ping test
$PING -c $PING_COUNT $IP_FOR_TEST > /dev/null 2> /dev/null
if [ $? -ge 1 ]
then
    logger "$INTERFACE seems to be down, trying to bring it up..."
        if [ -e $FLAG ]
        then
                logger "$INTERFACE is still down, REBOOT to recover ..."
                rm -f $FLAG 2>/dev/null
                sudo reboot
        else
                # set a flag so next time around we know it's already been down once
                touch $FLAG
                logger $(sudo $IFDOWN $INTERFACE)
                sleep 10
                logger $(sudo $IFUP $INTERFACE)
        fi
else
    logger "$INTERFACE is up"
    rm -f $FLAG 2>/dev/null
fi
