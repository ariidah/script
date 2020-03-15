' AUTHOR : @ariidah
' sudah RUNNING di komputer pribadi, terakhir update 2020 JANUARI 26.
' ---
' BIASAKAN DIBACA DULU
' Skrip ini sudah disesuaikan, untuk hardening blokir media penyimpanan USB tipe DISK.
' Skrip ini belum mendukung media external tipe MTP atau PTP.
' <!> WARNING <!>
' SKRIP INI SECARA DEFAULT MENGHAPUS FILE DENGAN EKSTENSI 'exe' DAN 'rar' YANG ADA DI MEDIA PENYIMPANAN USB (FLASHDISK, USB-HDD DAN LAIN-LAIN).
' RESIKO DITANGGUNG SENDIRI, SAYA TIDAK BERTANGGUNG JAWAB ATAS KERUGIAN APAPUN YANG DITIMBULKAN SCRIPT INI.
' ---

dim drive,sdrive
dim xa,xb
dim debug,blacklist
debug=false
blacklist=false
repeat=true

set fs = createObject("scripting.filesystemobject")
set sh = createObject("wscript.shell")
set sa = createObject("shell.application")
do while true
	on error resume next
	set wm = getObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	if ( wm <> nothing ) then exit do
	wscript.sleep 1000
loop

sub killprocess(byval ptarget)
	set w32_proc = wm.execquery("SELECT * FROM WIN32_PROCESS WHERE NAME LIKE '%" & ptarget & "%'")
	for each proc in w32_proc
		on error resume next
		proc.Terminate()
	next
	set w32_proc = nothing
end sub

sub openlock()
	key="HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}"
	sh.regwrite key&"\Deny_Write",0,"REG_DWORD"
	sh.regwrite key&"\Deny_Read",0,"REG_DWORD"
end sub
openlock

sub lockdown()
	key="HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}"
	sh.regwrite key&"\Deny_Write",1,"REG_DWORD"
	sh.regwrite key&"\Deny_Read",1,"REG_DWORD"
end sub

sub find_recurse(byval folder)
	if not fs.folderExists(folder) then
		if debug then
			wscript.echo "Drive : " & folder & " does not exist"
		end if
		exit sub
	end if
	set localdir=fs.getFolder(folder)
	for each file in localdir.files
		on error resume next
		extention=lcase(fs.getExtensionName(file.path))
		if ( extention = "exe" or extention = "rar" ) then
			if not blacklist then blacklist = true
			if debug then
				wscript.echo file.path
			else
'				<!> ---------- <!>
'				fs.deletefile file.path	'	<!> BARIS INI BERBAHAYA, GUNAKAN DENGAN HATI-HATI.
'				<!> ---------- <!>
			end if
		end if
	next
	for each folder in localdir.subfolders
		on error resume next
		find_recurse folder.path
	next
end sub

while true
	killprocess "conhost.exe"
	for each drive in fs.drives
		xa=xa+1
		if(drive.drivetype = 1 and ( xb < xa or repeat ) and drive.isready) then
			find_recurse drive.path
			if blacklist then
				while (drive.isready)
					on error resume next
					sa.namespace(17).parsename(drive).invokeverb("eject")
					wscript.sleep 1000
				wend
				lockdown
			end if
		end if
	next
	xb=fs.drives.count
	xa=0
	wscript.sleep 1000
wend
