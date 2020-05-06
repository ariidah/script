MAIN='imagemagick_resize.sh'
INSTALLDIR='/sdcard/Android/'
SOURCESDIR=`dirname -- "$0"`"/"
# ------------------------------
cp $SOURCESDIR$MAIN $INSTALLDIR
if [ ! `grep "bash $INSTALLDIR$MAIN" ~/.bashrc` ];then
	mv ~/.bashrc ~/.bashrc-`date +%y%m%d_%H%M%S`;
	printf "\
		\nbash $INSTALLDIR$MAIN\
		\nread;exit\
		\n" > ~/.bashrc
fi
printf "\033[32m[  OK  ]\033[00m SELESAI\nSilahkan mulai ulang Termux\n";
