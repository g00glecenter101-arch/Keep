Set shell = CreateObject("WScript.Shell")
' The "0" at the end tells Windows to hide the window entirely.
' "False" means the script won't wait for the batch to finish before closing.
shell.Run "cmd /c boom.bat", 0, False