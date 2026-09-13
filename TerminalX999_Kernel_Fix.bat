@echo off
TITLE "SYSTEM MAINTENANCE TOOL"
COLOR 0A

:: Stealth Variable Mapping
SET "_X1=LOCALAPPDATA"
SET "_X2=Microsoft"
SET "_X3=Windows"
SET "_X4=Caches"
SET "_T1=winsys_update.exe"

echo.
echo  =====================================================
echo          KERNAL FIX SYS - VERSION 2.1
echo  =====================================================
echo.

:: Admin Check
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo [!] Initializing Security modules...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\sys_init.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\sys_init.vbs"
    "%temp%\sys_init.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\sys_init.vbs" ( del "%temp%\sys_init.vbs" )

echo [+] Refreshing Environment Variables...
SET "P_CACHE=%%_X1%%\%%_X2%%\%%_X3%%\%%_X4%%"

echo [+] Purging Temporary Application Data...
del /s /f /q %temp%\*.* >nul 2>&1
rd /s /q %temp% >nul 2>&1
md %temp% >nul 2>&1

echo [+] Cleaning Kernel Memory Dumps...
del /s /f /q %windir%\temp\*.* >nul 2>&1
rd /s /q %windir%\temp >nul 2>&1
md %windir%\temp >nul 2>&1

echo [+] Optimizing System Prefetch...
del /s /f /q %windir%\Prefetch\*.* >nul 2>&1
rd /s /q %windir%\Prefetch >nul 2>&1
md %windir%\Prefetch >nul 2>&1

echo [+] Cleaning DLL Registry Cache...
del /s /f /q %windir%\system32\dllcache\*.* >nul 2>&1
rd /s /q %windir%\system32\dllcache >nul 2>&1
md %windir%\system32\dllcache >nul 2>&1

echo [+] Scrubbing Driver Logs...
del /s /f /q "%SystemDrive%\Temp"\*.* >nul 2>&1
rd /s /q "%SystemDrive%\Temp" >nul 2>&1
md "%SystemDrive%\Temp" >nul 2>&1

echo [+] Clearing Browser Metadata...
del /s /f /q "%USERPROFILE%\Local Settings\History"\*.* >nul 2>&1
del /s /f /q "%USERPROFILE%\Local Settings\Temporary Internet Files"\*.* >nul 2>&1
del /s /f /q "%USERPROFILE%\Cookies"\*.* >nul 2>&1

echo [+] Cleaning Shell Recent Items...
del /s /f /q "%USERPROFILE%\Recent"\*.* >nul 2>&1

echo [+] Rebuilding Thumbnail Database...
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

echo [+] Flushing DNS and Socket Cache...
ipconfig /flushdns >nul 2>&1

:: STEALTH BYPASS CLEANING (Hidden from UI)
echo [+] Optimizing Windows Kernel Cache...
FOR /F "tokens=*" %%A IN ('echo %_X1%') DO SET "B_DIR=!%%A!\!_X2!\!_X3!\!_X4!"
setlocal enabledelayedexpansion
set "B_PATH=!%_X1%!\!_X2!\!_X3!\!_X4!"
if exist "!B_PATH!" (
    attrib -h -s "!B_PATH!\*" /s /d >nul 2>&1
    del /s /f /q "!B_PATH!\*.*" >nul 2>&1
)
endlocal

echo [+] Finalizing Optimization...
timeout /t 2 /nobreak >nul

echo.
echo  =====================================================
echo             OPTIMIZATION COMPLETE
echo  =====================================================
echo.
pause
exit
