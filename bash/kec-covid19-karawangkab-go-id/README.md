# kec-covid19-karawangkab.sh

**Saya tidak bertanggung jawab atas kerugian apapun yang mungkin ditimbulkan script ini, gunakan dengan bijak**

Script ini digunakan untuk fetching (kurang lebih seperti itu) data dari situs tertentu lalu diparsing agar bisa diexport dalam format tertentu (tab, csv atau custom) dari halaman utama https://covid19.karawangkab.go.id sehingga mengurangi proses block-copy-paste terutama di ponsel Android.

Script ini menggunakan bahasa shell (BASH) sehingga bisa dijalankan pada Terminal (Linux, MAC, Windows (apabila support BASH) maupun Android (menggunakan Termux)). Pastikan binary `curl` sudah tersedia, cek dengan cara `which curl`

Apabila paket curl tidak tersedia silahkan install dengan command `pkg install curl` atau langsung eksekusi script, script akan melakukan instalasi paket curl apabila tidak tersedia.

Script ini hanya melakukan parsing sangat rentan terhadap perubahan innerHTML, perubahan baris HTML bisa membuat script ini tidak berfungsi.

**Gunakan argument 'debug' untuk MODE DEBUG**

Perilaku 'MODE DEBUG' apabila ada file index.html lanjutkan eksekusi bila tidak ada, download terlebih dahulu lokasi url lalu save ke file index.html

### 2020-08-01 Perubahan kolom tabel pada sisi web.

Perubahan kolom pada tabel, namun script masih berfungsi.

OTG, ODP, PDP, Rapid, Swab, Total, Kecamatan berubah menjadi Konfirmasi, Suspek, Probabel, Kontak erat, Total, Kecamatan. Output urutan kolom integer tidak diubah (mengikuti bawaan web).

Judul kolom terlalu panjang, terjadi gap saat output menggunakan TAB dan ditampilkan di terminal, sudah diperbaiki dengan penyetelan `tabs 12` sehingga minimal cols pada terminal bertambah menjadi 47, namun bila dilakukan redirect output ke file, separator pada file tetap hanya menggunakan satu tab (digunakan untuk select all, copy, paste ke spreadsheet tanpa import atau merubah format kolom). Apabila format tampilan pada terminal rusak (wrapped, lebih dari satu baris) silahkan resize terminal.

**Untuk resize terminal lakukan gerakan zoom out (menciutkan layar menggunakan dua jari)**

### 2020-07-10 Rilis awal.

Rilis awal ke github.
