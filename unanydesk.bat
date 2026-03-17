@echo off
title Full Uninstall AnyDesk - Silent Mode

:: ===== AUTO RUN AS ADMIN =====
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

setlocal enabledelayedexpansion

echo ================================
echo  FULL UNINSTALL ANYDESK (AUTO)
echo ================================
echo.

REM ==== Force kill process ====
echo [1/6] Killing AnyDesk process...
:killloop
taskkill /F /IM AnyDesk.exe >nul 2>&1
timeout /t 1 >nul
tasklist | find /I "AnyDesk.exe" >nul
if not errorlevel 1 goto killloop

REM ==== Stop & delete service ====
echo [2/6] Removing service...
sc stop AnyDesk >nul 2>&1
sc delete AnyDesk >nul 2>&1

REM ==== Take ownership & force delete Program Files ====
echo [3/6] Deleting program folder...
if exist "C:\Program Files (x86)\AnyDesk" (
    takeown /f "C:\Program Files (x86)\AnyDesk" /r /d y >nul 2>&1
    icacls "C:\Program Files (x86)\AnyDesk" /grant %username%:F /t >nul 2>&1
    rmdir /s /q "C:\Program Files (x86)\AnyDesk"
)

if exist "C:\Program Files\AnyDesk" (
    takeown /f "C:\Program Files\AnyDesk" /r /d y >nul 2>&1
    icacls "C:\Program Files\AnyDesk" /grant %username%:F /t >nul 2>&1
    rmdir /s /q "C:\Program Files\AnyDesk"
)

REM ==== Delete AppData ====
echo [4/6] Cleaning AppData...
rmdir /s /q "%appdata%\AnyDesk" >nul 2>&1
rmdir /s /q "%localappdata%\AnyDesk" >nul 2>&1
rmdir /s /q "%programdata%\AnyDesk" >nul 2>&1

REM ==== Delete registry ====
echo [5/6] Cleaning registry...
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk" /f >nul 2>&1
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\AnyDesk" /f >nul 2>&1
reg delete "HKCU\Software\AnyDesk" /f >nul 2>&1
reg delete "HKLM\Software\AnyDesk" /f >nul 2>&1
reg delete "HKLM\Software\WOW6432Node\AnyDesk" /f >nul 2>&1

echo.
echo =========================
echo  DONE - AUTO CLOSED
echo =========================

timeout /t 2 >nul
exit
