#rpi.sh
Saya gunakan untuk koneksi ssh (shell, sftp dan metode oneliner) dari ponsel ke raspberry pi, disesuaikan untuk koneksi over LAN maupun WLAN (tethering android) silahkan menyesuaikan variabel IP0,IP1 dan case wlan. Untuk mempersingkat waktu buat mengetik command.

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
