#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.03

rr_home="/home/pi/Raspi_Runner"
rr_storage="/home/pi/Raspi_Runner/Raspi_Commands"

cd $rr_home

#Download new scripts delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Raspi_Runner/Raspi_Commands
$rr_home/dropbox_uploader.sh -q download /Raspi_Commands

# Check for new files on Raspberry Pi
check=`ls $rr_storage | wc -l`

if [[ $check -eq 0 ]];
        then exit 0
fi

files=`ls $rr_storage`

# Grant rights for executing of delivered scripts
for i in $files
do
        chmod +x $rr_storage/$i
done

# Run all delivered scripts
for i in $files
do
        $rr_storage/$i > /dev/null 2>&1
done

# Push notification by Pushover

#If you are using Pushover, you can recieve push notification, with information, that scripts were executed.
#Remove hash symbols (#) from following 6 rows, and fill in information regarding APP_TOKEN & USER_KEY, which you recieved from Pushover.com

#time=`date`
#curl -s \
#  -F "token=APP_TOKEN" \
#  -F "user=USER_KEY" \
#  -F "message=$check script/s were executed at $time." \
#  https://api.pushover.net/1/messages.json > /dev/null 2>&1

# Remove all scripts, which were already executed from Dropbox
for i in $files
do
        $rr_home/dropbox_uploader.sh -q remove /Raspi_Commands/$i
done

# Remove all scripts, which were already executed from Raspberry Pi
rm $rr_storage/*
