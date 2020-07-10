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
	if [[ -z $wlan ]];then
		return 1;
	fi
	loginfo $wlan' network';
	case $wlan in
		$NET0)
			echo "$IP0";
			return 0;
			;;
		$NET1)
			echo "$IP1";
			return 0;
			;;
		*)
			return 2;
			;;
	esac
}

remote=`get_remote`

# CATCH ERROR
#===============================
case $? in
	1)
		logerror "Unable to get WLAN0 network";
		exit 1;
		;;
	2)
		logerror 'Network not registered';
		exit 2;
		;;
	*)
		;;
esac

if [[ $@ == 'sftp' ]];then
	loginfo "SFTP @$PWD";
	sftp pi@$remote;
	exit $?;
fi

if [[ -z $@ ]];then
	loginfo "SSH";
	ssh pi@$remote;
else
	loginfo "SSH ONELINER";
	ssh pi@$remote "$@";
fi
