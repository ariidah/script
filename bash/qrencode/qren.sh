#!/bin/bash

homedir='/sdcard/DCIM/Camera/'
backtitle="QRencode + ImageMagick"
info="Input *ANY* [$homedir]"
x=58;y=8
default=""
#default="`openssl rand -base64 15`"
font='/system/fonts/Roboto-Regular.ttf'

#escape slash
homedir=`echo $homedir|sed 's@\/@\\\/@g'`

function generateqr(){
	usrinput=`whiptail --backtitle "$backtitle" --inputbox "$info" "$y" "$x" "$default" 2>&1 > /dev/tty;`;echo $dialog
	[[ -z $usrinput ]] && return 1

	if [[ ${#usrinput} -gt 16 ]];then
		fname=`date +%F_%T.png|sed -E "s/^(http[s]?\:\/\/)//g;s/[^a-zA-Z0-9.-]/_/g;s/^/$homedir/g"`
	else
		fname=`echo "$usrinput"|sed -E "s/(http[s]?\:\/\/)//g;s/[^a-zA-Z0-9.-]/_/g;s/$/.png/g;s/^/$homedir/g"`
	fi
	qrencode -t ANSIUTF8 "$usrinput"
	qrencode -m 10 -s 30 -o "$fname" "$usrinput"
	[[ -n `which convert` ]] && convert "$fname" -font "$font" -pointsize 64 -size $((`identify "$fname"|cut -d' ' -f3|cut -d 'x' -f1` -20)) -gravity North caption:"$usrinput" -composite "$fname"
}
generateqr
