@ECHO OFF

REM Halo, ini script batch sederhana yang saya gunakan untuk membypass 'disabled command prompt'
REM di sistem operasi Windows, mungkin sudah tidak relevan lagi secara karena saya menggunakannya sewaktu SMK
REM di OS Windows XP, sedang sekarang sudah ada powershell di Windows 7 keatas.
REM Langsung saja. Ini script yang saya buat di notepad lalu di save as dengan extensi '.bat'.

:main
set /P command="command > "
%command%
goto main
