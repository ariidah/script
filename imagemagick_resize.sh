#!/bin/bash

# ------------------------------------------------------------
# @ariidah 2020-05-06
# kompresi tepatnya resize hasil jepretan kamera menggunakan
# imagemagick, whiptail (TUI) via Termux (Android)
# ------------------------------------------------------------

# ------------------------------------------------------------
# PRESET 
# ------------------------------------------------------------
x=64
y=20
z=10
DCIM="/sdcard/DCIM/Camera"
backtitle="ImageMagick -> Resize 2020-05-06"
shopt -s extglob;

# ------------------------------------------------------------
# LOG function
# ------------------------------------------------------------
function logfail(){
	printf "\033[1;31m[ FAIL ]\033[00m $@\n";
	return 0;
}
function loginfo(){
	printf "\033[1;33m[ INFO ]\033[00m $@\n";
	return 0;
}
function loglagi(){
	printf "\033[1;32m[  OK  ]\033[00m $@\n";
}

# ------------------------------------------------------------
# CATCH error 1
# ------------------------------------------------------------
if [ ! `printf "%s\n" "$PATH"|grep 'com.termux'` ];then
	logfail "Hanya jalankan di Termux";
	exit 1;
fi

# ------------------------------------------------------------
# CHDIR to Android DCIM Folder
# non production environment use cd $PWD/"Pictures";
# ------------------------------------------------------------
cd "$DCIM" 2>/dev/null;

# ------------------------------------------------------------
# CATCH error 2
# ------------------------------------------------------------
if [ "$?" -gt 0 ];then
	logfail "Tidak bisa akses ke $DCIM";
	loginfo "Diperlukan akses perizinan 'Penyimpanan' Silahkan googling sendiri";
	exit 2;
fi

if [ ! `which whiptail` -o ! `which convert` ];then
	loginfo "whiptail or ImageMagick does not exist."
	loglagi "running 'pkg install whiptail ImageMagick'"
	false;while [ $? -gt 0 ];do
		pkg install -y dialog imagemagick;
	done
fi

# ------------------------------------------------------------
# CATCH error 3
# for file in `find . -maxdepth 1 -type f`;do
# this function is deprecated, use BASH ONLY
#
# TODO : tambah multiple extension
#
# READ : https://stackoverflow.com/a/217208
# READ : https://stackoverflow.com/questions/40193122/how-to-sort-string-array-in-descending-order-in-bash#comment67652681_40193122
#
# array=(`printf '%s\n' "!(*z@(2|5|7)@(5|0)).$1"|sort -r`)
# ------------------------------------------------------------
function checkfiles(){
	array=("!(*z@(2|5|7)@(5|0))."$1);
	array=(`printf '%s\n' ${array[@]}|sort -r`);
	if [ ! -e ${array[0]} ];then
		logfail "no extention match"
		exit 3;
	fi
}
checkfiles jpg;

# ------------------------------------------------------------
# files[i]=`echo -ne "\0$(( $ii / 64 * 100 + $ii % 64 / 8 * 10 + $ii % 8))"`;
# this function is deprecated (use "A-Za-z" as index)
# READ : https://stackoverflow.com/a/1564725
# ------------------------------------------------------------

i=0;ii=0;

for file in ${array[@]};do
	files[i]=$ii;
	files[i+1]="$file";
	((i+=2));((ii++));
done

dfile=` \
	whiptail \
	--backtitle "$backtitle" \
	--title "Select File" \
	--menu "Please select Image File to resize\n[$PWD]" \
	$y $x $z "${files[@]}" \
	2>&1 > /dev/tty;`

# ------------------------------------------------------------
# CATCH error 4
# ------------------------------------------------------------
if [ "$?" != "0" ];then
	logfail "no input filename";
	exit 4;
fi

array=(25 50 75);
i=0;ii=0;

for res in ${array[@]};do
	preset[i]="$ii";
	preset[i+1]="$res";
	((i+=2));((ii++));
done

# ------------------------------------------------------------
# NOTES
# ${preset[@]} == ${preset[*]}
# ------------------------------------------------------------
dpercent=` \
	whiptail \
	--backtitle "$backtitle" \
	--title "Select Percentage" \
	--menu "Please select Output Percentage" \
	$y $x $z "${preset[@]}" \
	2>&1 > /dev/tty;`

# ------------------------------------------------------------
# CATCH error 5
# ------------------------------------------------------------
if [ "$?" != "0" ];then
	logfail "no resize selected";
	exit 5;
fi

# ------------------------------------------------------------
# NOTES
# files[] = "index, item"
# 0 * 2 + 1 = 1
# 1 * 2 + 1 = 3
# ------------------------------------------------------------
percent=${preset[dpercent*2+1]};
selected=${files[dfile * 2 + 1]};
outputed=`echo "$selected"|sed -E 's/(.{4})$/_z'$percent'\1/g'`

convert "$selected" -resize "$percent%" -strip -auto-orient "$outputed"

whiptail \
--backtitle "$backtitle" \
--msgbox "DONE !"  0  0;

# ------------------------------------------------------------
# TODO : kadang file output tidak tampil di Galeri, harus restart Galeri atau copy paste lagi pake file manager
# ------------------------------------------------------------
