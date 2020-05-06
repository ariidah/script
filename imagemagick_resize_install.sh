MAIN='imagemagick.sh'
INSTALLDIR='/sdcard/Android/'
SOURCESDIR=`dirname -- "$0"`"/"
# ------------------------------
cp $SOURCESDIR$MAIN $INSTALLDIR
printf "\
	\nbash $INSTALLDIR$MAIN\
	\nread;exit\
	\n" >> ~/.bashrc
printf "\033[32m[  OK  ]\033[00m SELESAI\nSilahkan mulai ulang Termux\n";
