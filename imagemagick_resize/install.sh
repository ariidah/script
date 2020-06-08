MAIN='imagemagick_resize.sh'
INSTALLDIR='/sdcard/Android/'
SOURCESDIR=`dirname -- "$0"`"/"
RCFILE='/data/data/com.termux/files/home/.bashrc'
function loginfo(){
	printf "\e[32m[ INFO ]\e[0m $@\n";
}
function tulis(){
cat << EOF > "$@";
bash $INSTALLDIR$MAIN;
read;exit;
EOF
}
# ------------------------------
cp $SOURCESDIR$MAIN $INSTALLDIR;
loginfo "Telah menyalin $MAIN ke $INSTALLDIR";

loginfo "Cek package ImageMagick dan whiptail"
if [ ! `which whiptail` -o ! `which convert` ];then
	loginfo "whiptail or ImageMagick does not exist."
	loginfo "running 'pkg install whiptail ImageMagick'"
	false;while [ $? -gt 0 ];do
		pkg install -y dialog imagemagick;
	done
fi

while true;do
	loginfo "Input 'YES/NO' untuk menimpa file .bashrc";read timpa;
	if [ -n "$timpa" ];then
		case $timpa in
			YES*)
				break;
				;;
			NO*)
				exit 1;
				;;
			*)
				loginfo "Hanya 'YES/NO'";
		esac
	else
		loginfo "Input tidak boleh kosong";
	fi
done
				
if ! `grep -q "bash $INSTALLDIR$MAIN" $RCFILE` ;then
	mv $RCFILE $RCFILE-`date +%y%m%d_%H%M%S`;
	tulis $RCFILE;
else
	loginfo "Ditemukan baris berikut, cek kembali file .bashrc"
	grep -Hn "$INSTALLDIR$MAIN" $RCFILE
	exit 2;
fi
loginfo "SELESAI ! Silahkan mulai ulang Termux";
