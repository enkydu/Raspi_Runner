Raspi Runner
============
Raspi Runner is a <b>BASH</b> script which will <b>run all your commands delivered by e-mail</b>. I created this script for my Raspberry Pi, because it is always up and online waiting for commands. But this script can be of course used by any Unix based system with bash shell. 

Prerequisites
============
1. Account on <a href='http://ifttt.com' target="_blank">IFTTT.com</a> - wicked sevice, for automatization!
2. Setup <a href='https://github.com/andreafabrizi/Dropbox-Uploader' target="_blank">Dropbox Uploader</a> - script for communication with Dropbox.
3. <a href='http://dropbox.com' target="_blank">Dropbox</a> account

Getting started
============

<h3>IFTTT Recipe Setup</h3>
Raspi Runner is using IFTTT service for distributing commands delivered by e-mail to Dropbox. You can find prepared recipe with this functionality here <a href='https://ifttt.com/recipes/105292' target="_blank">IFTTT Recipe</a>.

<h3>Raspi Runner Setup</h3>

Next step is installation of Raspi Runner. 

First, clone the repository using git:
```bash
git clone https://github.com/enkydu/raspi_runner
```
or download script manualy with command:
```bash
wget https://raw.github.com/enkydu/raspi_runner/master/raspi_runner.sh
```

<h4>raspi_runner.sh</h4> 
```bash
#!/bin/bash
#Author: Pavol Salgari
#Twitter: @enkydu
#Version: 1.01

rr_home="/home/pi/Dropbox"
rr_storage="/home/pi/Dropbox/Raspi_Commands"

cd $rr_home 

#Download new commands delivered by mail from Dropbox to Raspberry Pi folder /home/pi/Dropbox/Raspi_Commands
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
	$rr_storage/$i > /dev/null 2>&1
done

# Remove all commands, which were already executed from Dropbox
for i in $files
do
	$rr_home/dropbox_uploader.sh -q remove /Raspi_Commands/$i
done

# Remove all commands, which were already executed from Raspberry Pi
rm $rr_storage/*
```

<p>Raspi Runner is using two working directories:</p>
<p><b>rr_home</b> <i>(default: /home/pi/Dropbox/)</i> - directory with installation of Dropbox Uploader & Raspi Runner</p>
<p><b>rr_storage</b> <i>(default: /home/pi/Dropbox/Raspi_Commands)</i> - directory with delivered files with commands from Dropbox</p>

<i>NOTE: If you wanna change some of these folders, you have to also update these paths in <b>raspi_runner.sh!</b></i>

<h4>Schedule crontab</h4>

After initial setup, it is necessary to schedule crontab for scheduled running of Raspi Runner. For example, you can use 5 minutes delay. Raspi Runner will check Dropbox for delivered commands and will execute them each 5 minutes. 

Open crontab with command

```bash
crontab -e
```
and add new entry

```bash
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /home/pi/Dropbox/raspi_runner.sh > /dev/null 2>&1
```
Usage
============

<p>Usage of Raspi Runner is very simple. You just have to send e-mail with your BASH commands to e-mail address trigger@ifttt.com from your e-mail account, which you used for setup of IFTTT.com.</p>

<p>All commands delivered by e-mail to IFTTT.com will be converted to TXT files, which will be stored in folder Raspi_Commands on Dropbox. This folder is checked every 5 minutes by Raspi Runner and if any new file with commands is found, Raspi Runner will execute it. Thats it. Enjoy! ;)</p>
