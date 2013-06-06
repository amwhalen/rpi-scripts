#!/bin/bash

# Set your configuration options in /etc/default/rpi-timelapse

# directory check
if [[ -z "$SAVEDIR" ]]; then
    SAVEDIR=/home/pi/timelapse
fi

# delay check
if [[ -z "$DELAY" ]]; then
    DELAY=60
fi

# loop and take photos
while [ true ]; do

    hour=$(date +"%H")

    if [ $hour -ge 5 ] && [ $hour -le 20 ]; then

        directory=$SAVEDIR/$(date +"%Y-%m-%d")

        # make sure directory exists
        if [ ! -d "$directory" ]; then
            mkdir -p $directory
            if [ $? -ne 0 ]; then
                logger "Unable to create directory: ${directory}"
                exit 1
            fi
        fi

        filename=$(date +"%Y-%m-%d_%H-%M-%S").jpg

        /usr/bin/env raspistill -o $directory/$filename
        
        if [ $? -ne 0 ]; then
            logger "Unable to use raspistill to take a photo. Error codefrom raspistill: $?"
            exit 1
        else
            logger "Photo saved to: ${filename}"
        fi

    else
        logger "Not time for a photo."
    fi

    sleep $DELAY;

done;
