#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.00

#Download new commands delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Dropbox/Raspi_Commands
/home/pi/Dropbox/dropbox_uploader.sh -q download Raspi_Commands

# Check for new files on Raspberry Pi 
files=`ls /home/pi/Dropbox/Raspi_Commands`

# Grant rights for executing of delivered commands
for i in $files
do
	chmod +x /home/pi/Dropbox/Raspi_Commands/$i
done

# Run all delivered commands
for i in $files
do
	/home/pi/Dropbox/Raspi_Commands/$i 2>&1 > /dev/null
done

# Remove all commands, which were already executed from Dropbox
for i in $files
do
	/home/pi/Dropbox/dropbox_uploader.sh -q remove /Raspi_Commands/$i
done

# Remove all commands, which were already executed from Raspberry Pi
rm /home/pi/Dropbox/Raspi_Commands/*