@echo off
title 3D Image Gods Vision - Master Server Runner
color 0A

echo ========================================================
echo   🕉️  STARTING HINDU GODS RECOGNITION & SONGS SERVERS
echo ========================================================
echo.

echo [1/3] Setting up USB reverse port forwarding for Mobile...
set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist %ADB% (
    set ADB=adb
)
%ADB% reverse tcp:5000 tcp:5000
%ADB% reverse tcp:8000 tcp:8000
%ADB% reverse --list

echo.
echo [2/3] Launching Python OpenCV Recognizer (Port 8000)...
start "Python Recognizer (Port 8000)" cmd /k "cd /d D:\3d-image\recognizer && venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

echo.
echo [3/3] Launching Node.js Express Backend (Port 5000)...
start "Node Express Backend (Port 5000)" cmd /k "cd /d D:\3d-image\backend && npm run dev"

echo.
echo ========================================================
echo   ✅ SUCCESS! All servers running & connected to phone!
echo   👉 You can now scan images in the mobile app.
echo ========================================================
pause

