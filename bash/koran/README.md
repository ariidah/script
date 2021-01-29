# Koran

Sesuai namanya digunakan untuk membuat satu file berisi album gambar, mirip compressed file, tapi formatnya HTML dan portable, gambar di include menggunakan base64.

Menggunakan jQuery buat ngurangin tag (class, id) sudah include (simple) CSS.

Proses include gambar menggunakan base64, tidak cocok buat file yang banyak maupun sizenya besar, singkatnya setiap 3 byte data asal menjadi 4 byte kalo pake metode base64, belum termasuk HTML, CSS sama Javascript pastikan HANYA ada gambar di (folder to include).

## Usage
```
bash koran.sh [output] [folder to include]
```

Contoh :
```
bash koran.sh koran.html folder_gambar
```
