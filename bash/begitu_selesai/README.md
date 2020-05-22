Fungsi ini sebaiknya disisipkan pada file .bashrc, tujuanya untuk eksekusi suatu command setelah satu port tertutup, monitoring menggunakan parameter `netstat -n` (hanya menggunakan IP).

Skrip ini saya gunakan untuk mematikan raspberry setelah transfer file besar (via sftp) dari ponsel dengan mengandalkan port yang dibuka.

Eksekusi dengan argumen command yang akan dipanggil setelah port tertutup, lalu input port remote address yang akan dijadikan trigger, program yang di eksekusi akan dijalankan sebagai background process dan tidak akan menerima input dari user, selain itu apabila user logout process masih tetap berjalan.

`begitu_selesai sudo init 0`
