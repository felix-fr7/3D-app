@echo off
set "PATH=C:\Windows\System32\WindowsPowerShell\v1.0;C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\OpenSSH;C:\Program Files\Git\cmd;C:\Program Files\Git\bin;%LOCALAPPDATA%\Programs\Git\cmd;%PATH%"

echo ===================================================
echo Windows System & PowerShell PATH Restored!
echo ===================================================

where powershell.exe
where git.exe

cd /d "D:\3d-image\mobile"
flutter run
pause
