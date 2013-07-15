Raspi Runner
============
Raspi Runner is a <b>BASH</b> script which will <b>run all your commands delivered by e-mail</b>. I created this script for my Raspberry Pi, because it is always up and online waiting for commands. But this script can be of course used by any Unix based system with bash shell. 

Prerequisites
============
1. Account on <a href='http://ifttt.com'>IFTTT.com</a> - wicked sevice, for automatization!
2. Setup <a href='https://github.com/andreafabrizi/Dropbox-Uploader'>Dropbox Uploader</a> - script for communication with Dropbox.
3. <a href='http://dropbox.com'>Dropbox</a> account

Getting started
============

<h3>IFTTT Recipe Setup</h3>
Raspi Runner is using IFTTT service for distributing commands delivered by e-mail to Dropbox. You can find prepared recipe with this functionality here <a href='https://ifttt.com/recipes/105292'>IFTTT Recipe</a>.

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
```

<p>Raspi Runner is using few directories:</p>
<p><b>/home/pi/Dropbox/</b> - directory with installation of Dropbox Uploader & Raspi Runner</p>
<p><b>/home/pi/Dropbox/Raspi_Commands</b> - directory with delivered files with commands from Dropbox</p>

<i>NOTE: If you wanna change some of these folders, you have to also update these paths in <b>raspi_runner.sh!</b></i>

<h4>Schedule crontab</h4>

After initial setup, it is necessary to schedule crontab for scheduled running of Raspi Runner. For example, you can use 5 minutes delay. Raspi Runner will check Dropbox for delivered commands and will execute them each 5 minutes. 

Open crontab with command

```bash
crontab -e
```
and add new entry

```bash
0,5,10,15,20,25,30,35,40,45,50,55 * * * * /home/pi/Dropbox/raspi_runner.sh 2>&1 > /dev/null
```
