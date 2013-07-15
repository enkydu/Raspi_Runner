#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.01

rr_home="/home/pi/Raspi_Runner"
rr_storage="/home/pi/Raspi_Runner/Raspi_Commands"

cd $rr_home 

#Download new commands delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Raspi_Runner/Raspi_Commands
$rr_home/dropbox_uploader.sh -q download /Raspi_Commands

# Check for new files on Raspberry Pi 
files=`ls $rr_storage`

# Grant rights for executing of delivered commands
for i in $files
do
	chmod +x $rr_storage/$i
done

# Run all delivered commands
for i in $files
do
	$rr_storage/$i 2>&1 > /dev/null
done

# Remove all commands, which were already executed from Dropbox
for i in $files
do
	$rr_home/dropbox_uploader.sh -q remove /Raspi_Commands/$i
done

# Remove all commands, which were already executed from Raspberry Pi
rm $rr_storage/*
