#!/bin/bash
# Fri Jul 10 20:25:43 WIB 2020
# author @ariidah (https://github.com/ariidah)
# writen using vi or vim

# README
# Saya tidak bertanggung jawab atas kerugian apapun yang mungkin ditimbulkan script ini, gunakan dengan bijak.

# Script ini digunakan untuk fetching (kurang lebih seperti itu) data dari situs tertentu lalu diparsing
# agar bisa diexport dalam format tertentu (tab, csv atau custom) dari halaman utama
# https://covid19.karawangkab.go.id sehingga mengurangi proses block-copy-paste terutama di ponsel Android.

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
format='TAB';

# kecamatan bisa diubah, untuk semua isi 'ALL' CASE SENSITIVE.
kecamatan='KOTA BARU';
#kecamatan='ALL';

# variabel yang bisa diubah tanpa mengubah fungsi script berakhir di sini.
#===============================

# opsi 'curl -k' terima insecure SSL certificate
curl='curl -k -L -s';
url='https://covid19.karawangkab.go.id';
last_update_begin='Update terakhir Tanggal';
case $kecamatan in
	all|ALL)
		begin_data='tbody';
		endof_data='/tbody';
		;;
	*)
		begin_data="$kecamatan";
		endof_data='/th';
		;;
esac
begin_numbering='<tr><td>';
endof_numbering='</td>';
line='</tr>';
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
	begin_data=`realescape "$begin_data"`;
	endof_data=`realescape "$endof_data"`;
	begin_numbering=`realescape "$begin_numbering"`;
	endof_numbering=`realescape "$endof_numbering"`;
	line=`realescape "$line"`;
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
printf "URL\t%s\n" "$url" >&2;

# s/[^a-zA-Z0-9/ <>!_-]//g;    -< remove character else
# s/>\( \)*/>/g;               -< '...> DATA' to '...>DATA'
# s/\( \)*</</g;               -< 'DATA <...' to 'DATA<...'
# s/$begin_numbering[0-9]*$endof_numbering//g  -< remove numbering
# s/$line/\n/g;                -< add newline mode kecamatan='ALL'
# s/<[^>]*>/$separator/g;      -< <...>DATA<...><...>DATA<...> to 'DATA(separator)DATA'
# s/$separator\1\+/$separator  -< remove duplicate separator
# s/\(^\|\n\)$separator/\1/g;  -< ^(separator)DATA to ^DATA
# s/$separator\($\|\n\)/\1/g;  -< DATA(separator)$ to DATA$
# s/\n$//g                     -< remove additional newline
function cleanview(){
	echo "$@"|sed "s/[^a-zA-Z0-9/ <>!_-]//g;s/>\( \)*/>/g;s/\( \)*</</g;s/$begin_numbering[0-9]*$endof_numbering//g;s/$line/\n/g;s/<[^>]*>/$separator/g;s/\($separator\)\1\+/\1/g;s/\(^\|\n\)$separator/\1/g;s/$separator\($\|\n\)/\1/g;s/\n$//g"
	return 0;
}

# s/\([a-zA-Z ]*\)$separator\(.*\)/\2$separator\1/g  -< $1:$* to $*:$1
report_date=$(cleanview `printf '%s' "$buffer"|sed -n "/$last_update_begin/p"|sed "s/$last_update_begin//g"`);
printf "$report_date\n";
cleanview `printf '%s' "$buffer"|sed -n "/$begin_header/,/$endof_header/p"|sed -n "/$begin_data_header/,/$endof_data_header/p"|tr -d '\n'`|sed "s/\([a-zA-Z ]*\)$separator\(.*\)/\2$separator\1/g"; >&2;
cleanview `printf '%s' "$buffer"|sed -n "/$begin_data/,/$endof_data/p"|tr -d '\n'`|sed "s/\([a-zA-Z ]*\)$separator\(.*\)/\2$separator\1/g";
