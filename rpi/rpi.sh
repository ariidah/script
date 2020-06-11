#!/bin/bash
IP0='192.168.43.254';
IP1='192.168.1.2';
NET0='43.168.192';
NET1='88.168.192';
function logerror(){
	printf "\e[1;31m[ FAIL ]\e[0m %s\n" "$@" >&2;
}
function loginfo(){
	printf "\e[1;33m[ INFO ]\e[0m %s\n" "$@" >&2;
}
function get_remote(){
	wlan=`ifconfig wlan0|awk '/inet /{print $2}'|awk -F'.' '{print $3"."$2"."$1}'`
	if [[ -n $wlan ]];then
		loginfo $wlan' network'
	fi
	case $wlan in
		$NET0*)
			echo "$IP0";
			return 0;
			;;
		$NET1*)
			echo "$IP1";
			return 0;
			;;
		*)
			return 1;
			;;
	esac
}
remote=`get_remote`

# CATCH ERROR 1
#===============================
if [[ $? -gt 0 ]];then
	logerror 'Network not registered';
	exit 1;
fi

if `echo "$@"|grep -q sftp`;then
	loginfo "SFTP @$PWD";
	sftp pi@$remote;
	exit $?;
fi

# $0 sudo pam_tally2 --user
# [ -z "$@" ] -> [: too many arguments
# [[ -z $@ ]] -> fixed
#===============================
if [[ -z $@ ]];then
	loginfo "SSH";
	ssh pi@$remote;
else
	loginfo "SSH ONELINER";
	ssh pi@$remote "$@";
fi
