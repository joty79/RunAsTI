Set WshShell = CreateObject("WScript.Shell")
Q = Chr(34)

If WScript.Arguments.Count = 0 Then WScript.Quit

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
        Args = Args & " " & Q & arg & Q
    Next
    objShell.ShellExecute "wscript.exe", Q & WScript.ScriptFullName & Q & Args, "", "runas", 0
    WScript.Quit
End If

If WScript.Arguments.Count > 1 Then
    CmdPart = ""
    For i = 0 To WScript.Arguments.Count - 1
        CmdPart = CmdPart & " " & WScript.Arguments(i)
    Next
    FinalCmd = Trim(CmdPart)
Else
    Target = WScript.Arguments(0)
    If Right(Target, 1) = "\" Then Target = Left(Target, Len(Target) - 1)
    FinalCmd = Q & Target & Q
End If

WshShell.Run FinalCmd, 1, False
