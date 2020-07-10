#!/bin/bash
# Fri Jul 10 20:25:43 WIB 2020
# author @ariidah (https://github.com/ariidah)
# writen using vi or vim

# README
# Saya tidak bertanggung jawab atas kerugian apapun yang mungkin ditimbulkan script ini, gunakan dengan bijak.

# Script ini digunakan untuk fetching (kurang lebih seperti itu) data dari situs tertentu lalu diparsing
# agar bisa diexport dalam format tertentu (tab, csv atau custom) dari halaman utama
# https://covid19.karawangkab.go.id sehingga mengurangi proses block-copy-paste terutama di ponsel Android, sementara ini hanya bisa digunakan untuk mengambil data satu kecamatan saja.

# Script ini menggunakan bahasa shell (BASH) sehingga bisa dijalankan pada Terminal
# (Linux, MAC, Windows (apabila support BASH) maupun Android (menggunakan Termux)).
# pastikan binary `curl` sudah tersedia, cek dengan cara `which curl`

# Script ini hanya melakukan parsing
# sangat rentan terhadap perubahan innerHTML, perubahan baris HTML bisa membuat script ini tidak berfungsi.

# Gunakan argument 'debug' untuk MODE DEBUG
# Perilaku 'MODE DEBUG' apabila ada file index.html lanjutkan eksekusi
# bila tidak ada, download terlebih dahulu lokasi url lalu save ke file index.html

# variabel yang bisa diubah tanpa mengubah fungsi script dimulai di sini.
#===============================

# format bisa TAB, CSV atau custom (isi sendiri)
format='CSV';

# kecamatan bisa diubah, CASE SENSITIVE.
kecamatan='KOTA BARU';

# variabel yang bisa diubah tanpa mengubah fungsi script berakhir di sini.
#===============================

# opsi 'curl -k' terima insecure SSL certificate
curl='curl -k -L -s';
url='https://covid19.karawangkab.go.id';
last_update_begin='Update terakhir Tanggal';
begin_data_kecamatan="$kecamatan";
endof_data_kecamatan='/tr';
begin_header='!-- famne data --';
endof_header='/thead';
begin_data_header='Kecamatan';
endof_data_header='/tr';

case $format in
	tab|TAB)
		separator='\t';
		;;
	csv|CSV)
		separator=',';
		;;
	*)
		separator=$format;
		;;
esac

function realescape(){
	echo -n "$@"|sed -E 's/([/!])/\\\1/g';
	return 0;
}

function escapestring(){
	begin_data_kecamatan=`realescape "$begin_data_kecamatan"`;
	endof_data_kecamatan=`realescape "$endof_data_kecamatan"`;
	header=`realescape "$header"`;
	begin_header=`realescape "$begin_header"`;
	endof_header=`realescape "$endof_header"`;
	begin_data_header=`realescape "$begin_data_header"`;
	endof_data_header=`realescape "$endof_data_header"`;
	return 0;
}
escapestring;

if `echo $1|grep -q -i 'debug'`;then
	if ! [[ -f index.html ]];then
		$curl -o index.html "$url";
	fi
		buffer=`cat index.html`;
else
	buffer=`$curl "$url"`;
fi

# s/[^a-zA-Z0-9/ <>!_-]//g;    -< remove character else
# s/> />/g;                    -< '...> DATA' to '...>DATA'
# s/ </</g;                    -< 'DATA <...' to 'DATA<...'
# s/<[^>]*>/$separator/g;      -< <...>DATA<...><...>DATA<...> to 'DATA(separator)[0-9]'
# s/$separator\1\+/$separator  -< remove duplicate separator
# s/^$separator//g             -< ^(separator)DATA to ^DATA
# s/$separator$//g             -< DATA(separator)$ to DATA$
# s/ $separator//g             -< '(separator) DATA' to '(separator)DATA'
# s/$separator //g             -< 'DATA(separator) ' to 'DATA(separator)'
function cleanview(){
	echo "$@"|sed "s/[^a-zA-Z0-9/ <>!_-]//g;s/> />/g;s/ </</g;s/<[^>]*>/$separator/g;s/\($separator\)\1\+/\1/g;s/^$separator//g;s/$separator$//g;s/$separator /$separator/g;s/ $separator/$separator/g";
	return 0;
}
report_date=$(cleanview `printf '%s' "$buffer"|sed -n "/$last_update_begin/p"|sed "s/$last_update_begin//g"`);
printf '%s' "Tanggal$separator" >&2;
cleanview `printf '%s' "$buffer"|sed -n "/$begin_header/,/$endof_header/p"|sed -n "/$begin_data_header/,/$endof_data_header/p"|tr -d '\n'` >&2;
printf '%s' "$report_date$separator";
cleanview `printf '%s' "$buffer"|sed -n "/$begin_data_kecamatan/,/$endof_data_kecamatan/p"|tr -d '\n'`;
