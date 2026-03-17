@echo off
echo ================================
echo  FULL UNINSTALL ANYDESK BY TEWE
echo ================================
echo.

REM ==== Stop AnyDesk services ====
echo Stopping AnyDesk service...
sc stop AnyDesk >nul 2>&1
sc delete AnyDesk >nul 2>&1

REM ==== Kill AnyDesk process ====
echo Killing AnyDesk process...
taskkill /F /IM anydesk.exe >nul 2>&1

REM ==== Delete Program Files folder ====
echo Deleting program folder...
if exist "C:\Program Files (x86)\AnyDesk" (
    rmdir /s /q "C:\Program Files (x86)\AnyDesk"
)

REM ==== Delete AppData leftovers ====
echo Deleting leftover AppData folders...
rmdir /s /q "%appdata%\AnyDesk" >nul 2>&1
rmdir /s /q "%localappdata%\AnyDesk" >nul 2>&1

REM ==== Delete registry keys (ONLY AnyDesk) ====
echo Removing registry entries...

REM HKLM 32-bit uninstall entry
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk" /f >nul 2>&1

REM HKLM 64-bit uninstall entry
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk" /f >nul 2>&1

REM Service registry key
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\AnyDesk" /f >nul 2>&1

REM App registry keys
reg delete "HKCU\Software\AnyDesk" /f >nul 2>&1
reg delete "HKLM\Software\AnyDesk" /f >nul 2>&1
reg delete "HKLM\Software\WOW6432Node\AnyDesk" /f >nul 2>&1

echo.
echo =========================
echo  AnyDesk uninstalled!
echo =========================
exit
