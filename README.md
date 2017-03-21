Raspi Runner
============
Raspi Runner is a <b>BASH</b> script which will <b>run all your scripts delivered by e-mail</b>. I created this script for my Raspberry Pi, because it is always up and online waiting for commands. But this script can be of course used by any Unix based system with bash shell. 

Requirements
============
1. Account on <a href='http://ifttt.com' target="_blank">IFTTT.com</a> - wicked sevice, for automatization!
2. Setup <a href='https://github.com/andreafabrizi/Dropbox-Uploader' target="_blank">Dropbox Uploader</a> - script for communication with Dropbox. Make sure, that Raspi Runner will be installed in a same folder like Dropbox Uploader!
3. <a href='http://dropbox.com' target="_blank">Dropbox</a> account
4. <a href='https://pushover.net' target="_blank">Pushover</a> or free <a href='https://pushbullet.com' target="_blank">Pushbullet</a> account (optional) - if you wanna use notifications delivered to your smartphone

Getting started
============

<h3>IFTTT Recipe Setup</h3>
Raspi Runner is using IFTTT service for distributing commands delivered by e-mail to Dropbox. You can find prepared recipe with this functionality here <a href='https://ifttt.com/recipes/105292' target="_blank">IFTTT Recipe</a>.

<h3>Dropbox Uploader Setup</h3>
Now you have to setup Dropbox Uploader according to <a href='https://github.com/andreafabrizi/Dropbox-Uploader' target="_blank">user guide here</a>. Then create dedicated folder for our files with commands on Dropbox, which will be delivered by e-mail (for example: Raspi_Commands). This Dropbox folder will be checked by Raspi Runner every 5 minutes. 

<h3>Raspi Runner Setup</h3>
Last step is installation of Raspi Runner. 

First, clone the repository using git:
```bash
git clone https://github.com/enkydu/Raspi_Runner
```
or download script manually with command:
```bash
wget https://raw.github.com/enkydu/Raspi_Runner/master/raspi_runner.sh
```

<h4>Initial setup of Raspi Runner</h4>
<p>For quick configuration of Raspi Runner, please make script executable</p>

```bash
chmod +x raspi_runner.sh
```
<p>and start it with command</p>

```bash
./raspi_runner.sh
```
<p>Raspi Runner will ask you few questions during initial setup.</p>
<p>After this, Raspi Runner will create <b>raspi_runner.cfg</b> file with configuration.</p>

```bash
./raspi_runner.sh
You started Raspi Runner for the first time.
Please answer few questions, which will be used for creation of config file.

What is name of Dropbox folder, for Raspi Runner commands? (i.e. Raspi_Commands): Raspi_Commands
what is the full path to your Dropbox Uploader? (i.e. /home/pi/Dropbox_Uploader): /home/pi/Dropbox_Uploader


Please check, if displayed information are correct.
***************************************************
Name of Dropbox folder: Raspi_Commands
Full path to Dropbox Uploader installation: /home/pi/Dropbox_Uploader

Are these values correct? [y/n]: y

Raspi Runner setup is finished!
***************************************
Please continue with setup of crontab according to README.
If you are planning to use Pushover notifications on your smartfone,
please follow instructions in README too. Little changes in Raspi Runner
script will be necessary.

Enjoy!
```
<h4>Pushover setup</h4>
You can recieve notification on your smartphone after execution of scripts. This is provided by service <a href='https://pushover.net' target="_blank">Pushover.net</a>. You have to fill in information regarding your <b>APP_TOKEN</b> & <b>USER_KEY</b> and remove hash symbols (#) in front of rows to activate this functionality. 

<h4>Schedule crontab</h4>

After initial setup, it is necessary to schedule crontab for scheduled running of Raspi Runner. For example, you can use 5 minutes delay. Raspi Runner will check Dropbox for delivered commands and will execute them each 5 minutes. 

Open crontab with command

```bash
crontab -e
```
and add new entry

```bash
*/5 * * * * /home/pi/Raspi_Runner/raspi_runner.sh > /dev/null 2>&1
```
Usage
============

<p>Usage of Raspi Runner is very simple. You just have to send e-mail with your BASH commands to e-mail address trigger@recipe.ifttt.com. from your e-mail account, which you used for setup of IFTTT.com.</p>

<p>All commands delivered by e-mail to IFTTT.com will be converted to TXT files, which will be stored in folder e.i. Raspi_Commands on Dropbox. This folder is checked every 5 minutes by Raspi Runner and if any new file with commands is found, Raspi Runner will execute it. Thats it. Enjoy! ;)</p>
