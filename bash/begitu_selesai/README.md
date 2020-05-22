Fungsi ini sebaiknya disisipkan pada file .bashrc, untuk eksekusi suatu command setelah satu port tertutup, monitoring menggunakan parameter `netstat -n` (hanya menggunakan IP).

Skrip ini saya gunakan untuk mematikan PC setelah transfer file besar (via sftp) dari ponsel dengan mengandalkan port yang dibuka.

Eksekusi dengan argumen command yang akan dipanggil setelah port tertutup, lalu input port remote address yang akan dijadikan trigger, argumen dan trigger akan berjalan sebagai background process tidak akan menerima input dari user, selain itu apabila user logout process masih tetap berjalan.

`begitu_selesai sudo init 0`

Note : 'sudo' membutuhkan input password maka dari awal harus running as root atau menambahkan file baru (tanpa ekstensi) pada /etc/sudoers.d/

```$ echo -e "`id -n`\tALL=(ALL)\tNOPASSWD:/sbin/init 0"|sudo tee -a /etc/sudoers.d/`id -u`-`id -n` ```
