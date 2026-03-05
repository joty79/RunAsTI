If WScript.Arguments.Count = 0 Then WScript.Quit

Set WshShell = CreateObject("WScript.Shell")

' 🔵 Check for Elevation
Function IsAdmin()
    On Error Resume Next
    WshShell.RegRead "HKEY_USERS\S-1-5-19\Environment\TEMP"
    If Err.Number = 0 Then IsAdmin = True Else IsAdmin = False
    On Error GoTo 0
End Function

If Not IsAdmin() Then
    Set objShell = CreateObject("Shell.Application")
    Args = ""
    For Each arg In WScript.Arguments
        Args = Args & " " & Chr(34) & arg & Chr(34)
    Next
    objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & Args, "", "runas", 0
    WScript.Quit
End If

' 🔵 Main Logic
TargetFile = WScript.Arguments(0)
Quote = Chr(34)
RunAsTI_Script = "D:\Users\joty79\scripts\Utilities\TakeOwnership\RunAsTI.ps1"

' 🔵 Calls RunAsTI.ps1 with -TargetFile ONLY
' This avoids all complex nested quoting issues.
TargetArgs = "-TargetFile " & Quote & TargetFile & Quote

PsCmd = "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File " & Quote & RunAsTI_Script & Quote & " " & TargetArgs

Command = "pwsh " & PsCmd

' 🔵 Debug Configuration (Set to True to enable logging)
Const DebugMode = False

If DebugMode Then
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set logFile = fso.CreateTextFile("D:\Users\joty79\scripts\Utilities\TakeOwnership\debug_vbs.txt", True)
    logFile.WriteLine "TimeStamp: " & Now
    logFile.WriteLine "TargetFile: " & TargetFile
    logFile.WriteLine "FullCommand: " & Command
    logFile.Close
End If

WshShell.Run Command, 0, False
