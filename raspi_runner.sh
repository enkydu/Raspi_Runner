#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.04

# Check location of Raspi Runner
script_path="$(readlink -f ${BASH_SOURCE[0]})"
rr_home="$(dirname $script_path)"

cd $rr_home

# Check if there is any configuration file (raspi_runner.cfg) for Raspi Runner avaliable
cfg=`ls . | grep raspi_runner.cfg | wc -l`

# If NOT, then create new configuration file
if [[ $cfg -eq 0 ]]; then
        echo "You started Raspi Runner for the first time."
        echo "Please answer few questions, which will be used for creation of config file."
        echo
                        while (true); do
                                echo -n "What is name of Dropbox folder, for Raspi Runner commands? (i.e. Raspi_Commands): "
                                read rr_storage
                                echo -n "Is name $rr_storage right one? [y/n]: "
                                read answer
                                        if [[ $answer == y ]]; then
                                                break;
                                        fi
                        done
        echo
        echo "Your actual Raspi Runner configuration:"
        echo "***************************************"
        echo "Installation folder: $rr_home"
        echo "Dropbox folder name: $rr_storage"
        mkdir $rr_storage
        echo "Your local copy of Dropbox folder: $rr_home/$rr_storage"
        echo
        echo
        echo "rr_storage=$rr_home/$rr_storage" > raspi_runner.cfg
fi

# Load configuration file for Raspi Runner
. raspi_runner.cfg

# Download new scripts delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Raspi_Runner/Raspi_Commands
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

# If you are using Pushover, you can recieve push notifications, with information, that scripts were executed.
# Remove hash symbols (#) from following 6 rows, and fill in information regarding APP_TOKEN & USER_KEY, which you recieved from Pushover.com

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
