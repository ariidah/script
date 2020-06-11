#rpi.sh
Saya gunakan untuk koneksi ssh (shell, sftp dan metode oneliner) dari ponsel ke raspberry pi, disesuaikan untuk koneksi over LAN maupun WLAN (tethering android) silahkan menyesuaikan variabel IP0,IP1,NET0,NET1 dan case wlan. Untuk mempersingkat waktu buat mengetik command.

Normal

```
sftp pi@192.168.4.3
ssh pi@192.168.43.254
ssh pi@192.168.4.3 'sudo init 0'
```

Hanya file rpi.sh

```
bash rpi.sh
bash rpi.sh sftp
bash rpi.sh sudo init 0
```

Edit file .bashrc

```
cat << EOF|tee -a .bashrc
function rpi(){
	bash rpi.sh "$@";
}
EOF
```

rpi.sh + .bashrc

```
rpi
rpi sftp
rpi sudo init 0
```

Note :

Fungsi yang di integrasikan dengan .bashrc secara default belum bisa dieksekusi, untuk melakukannya mohon baca https://stackoverflow.com/a/4173744, pada file .bashrc saya (Raspbian 9) :

```
case $- in
    *i*) ;;
      *) return;;
esac
```

Mengenai $- silahkan baca https://stackoverflow.com/questions/5163144

Awalnya saya coba buat export variable, ternyata tidak mungkin. Akhirnya saya modifikasi file .bashrc menjadi :

```
if ! `/usr/bin/pstree -s $$|/bin/grep -q sshd`;then
   case $- in
       *i*) ;;
         *) return;;
   esac
fi
```

Saya masih mencari cara untuk membedakan koneksi via ssh atau lokal, sementara meggunakan pstree untuk mencari parent process dari bash asalkan ada parent process sshd, silahkan baca https://askubuntu.com/questions/153976

Eksekusi untuk menginclude file .bashrc, diasumsikan ada fungsi "wakepc" sejauh ini baru bisa function bukan alias.

```
rpi.sh wakepc
```
