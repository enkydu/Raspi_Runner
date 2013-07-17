#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.06

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
                                read rr_dboxstorage
                                echo -n "what is the full path to your Dropbox Uploader? (i.e. /home/pi/Dropbox_Uploader): "
                                read rr_dbuploader
                                echo
                                echo
                                echo "Please check, if displayed information are correct."
                                echo "***************************************************"
                                echo "Name of Dropbox folder: $rr_dboxstorage"
                                echo "Full path to Dropbox Uploader installation: $rr_dbuploader"
                                echo
                                echo -n "Are these values correct? [y/n]: "
                                read answer
                                        if [[ $answer == y ]]; then
                                                break;
                                        fi
                        done
        echo
        echo "Raspi Runner setup is finished!"
        echo "***************************************"
        echo "Please continue with setup of crontab according to README."
        echo "If you are planning to use Pushover notifications on your smartfone,"
        echo "please follow instructions in README too. Little changes in Raspi Runner"
        echo "script will be necessary."
        echo
        echo "Enjoy!"
        echo
        mkdir $rr_dboxstorage
        echo "rr_dboxstorage=$rr_dboxstorage" > raspi_runner.cfg
        echo "rr_storage=$rr_home/$rr_dboxstorage" >> raspi_runner.cfg
        echo "rr_dbuploader=$rr_dbuploader" >> raspi_runner.cfg
fi

# Load configuration file for Raspi Runner
. raspi_runner.cfg

# Download new scripts delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Raspi_Runner/Raspi_Commands
$rr_dbuploader/dropbox_uploader.sh -q download /$rr_dboxstorage

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
#  -F "message=$check script/s executed at $time." \
#  https://api.pushover.net/1/messages.json > /dev/null 2>&1

# Remove all scripts, which were already executed from Dropbox
for i in $files
do
        $rr_dbuploader/dropbox_uploader.sh -q remove /$rr_dboxstorage/$i
done

# Remove all scripts, which were already executed from Raspberry Pi
rm $rr_storage/*
