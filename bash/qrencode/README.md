# qrencode

### DISCLAIMER

SAYA TIDAK BERTANGGUNG-JAWAB ATAS KERUGIAN APAPUN YANG MUNGKIN DAN DIHASILKAN DARI SCRIPT INI.

Script ini digunakan untuk generate qrcode menggunakan libqrencode pada ponsel Android dengan environment Termux. Script ini dibuat dengan tujuan mempermudah saya dalam proses sharing link URL.

Contoh kasusnya pada saat job fair minggu ini; link pendaftaran dibacakan oleh penyelenggara, banyak yang salah input URL, kebetulan saya benar lalu tidak sampai disitu saja; saya juga membagi tepatnya memberikan layar ponsel saya yang tertera URL tersebut pada address bar, awalnya rekan sekitar saya mengeja satu-persatu karakter, 5 menit kemudian disertai typo akhirnya rekan sekitar saya meminta untuk difoto saja layarnya. I do respect, baik penyelenggara, maupun rekan sekitar saya. Mata bisa jadi hanya menguntungkan pihak yang berada dekat dengan penyelenggara, opsi suara adalah pilihan yang baik; sedang sesama job seeker, toh belum tentu semisal saya pelit akan membawa dampak positif.

Berhubung sekarang ini mayoritas ponsel Android sudah menerapkan fitur qrcode reader pada aplikasi kameranya (tidak perlu instalasi aplikasi lain) jadi deh tercetus ide ini.

Penggunaan bagi yang akan menerima qrcode bisa mengambil gambar layar terlebih dahulu bisa difoto, baru klik informasi kode qr (menyesuaikan, biasanya ada di area bidikan kamera) sehingga proses sharing informasi (qrcode) bisa efektif. Foto baru decode qrcode buka URL, salin dan buka di browser, setelah laman terbuka, isi data sembari bantu kalo ada yang nanyain URL (prosesnya sama kok, bidik pake kamera bawaan).

Untuk instalasi awal silahkan run install.sh lalu untuk generate qrcode silahkan eksekusi qren.sh; input teks yang akan dijadikan qrcode lalu OK/enter.

Script ini akan menampilkan qrcode dalam terminal (langsung pakai) sekaligus menyimpan hasil generate qrcode ke direktori (default : /sdcard/DCIM/Camera) apabila panjang karakter yang digenerate < 16 file akan diberi nama beberapa karakter terakhir dari karakter yang digenerate, selebihnya akan diberi nama berdasarkan tanggal eksekusi.

Apabila package ImageMagick tersedia; akan dibuat teks diatas file qrcode yang digenerate. Fitur ini masih eksperimental.

Resolusi terminal yang disarankan min. 62 cols.
