#!/bin/bash
toinstall=""
if [[ -z `which qrencode` ]];then
	echo "WILL install libqrencode"
	toinstall=$toinstall" libqrencode"
fi
if [[ -z `which dialog` ]];then
	echo "WILL install dialog"
	toinstall=$toinstall" dialog"
fi
if [[ -z `which convert` ]];then
	echo -n "Install ImageMagick? need `pkg show imagemagick 2>/dev/null|awk '/Download-Size: /{print $2$3}'` [y/n] : "
	read response;
	false;while [[ $? -ne 0 ]];do
	case $response in
		y|Y)
			echo "WILL install ImageMagick"
			toinstall=$toinstall" imagemagick"
			;;
		n|N)
			echo "SKIP package ImageMagick"
			;;
		*)
			echo "Invalid response"
			false
			;;
	esac
	done
fi

if [[ -n $toinstall ]];then
false;while [[ $? -ne 0 ]];do
	pkg install -y $toinstall
done
fi
echo "Selesai"
