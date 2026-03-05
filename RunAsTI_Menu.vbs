Set WshShell = CreateObject("WScript.Shell")
Q = Chr(34)

If WScript.Arguments.Count = 0 Then WScript.Quit

' --- Smart Logic για Σύνθετες Εντολές ---
If WScript.Arguments.Count > 1 Then
    ' Ενώνουμε τα ορίσματα χωρίς να προσθέτουμε επιπλέον quotes που χαλάνε το Regedit
    CmdPart = ""
    For i = 0 To WScript.Arguments.Count - 1
        CmdPart = CmdPart & " " & WScript.Arguments(i)
    Next
    FinalCmd = Trim(CmdPart)
Else
    ' Για απλά αρχεία (EXE, Folders)
    Target = WScript.Arguments(0)
    If Right(Target, 1) = "\" Then Target = Left(Target, Len(Target) - 1)
    FinalCmd = Q & Target & Q
End If

' Η εντολή PowerShell (Ninja Mode)
PSCmd = "powershell -WindowStyle Hidden -NoProfile -Command " & Q & "iex((10..40|%{(gp 'Registry::HKCR\RunAsTI' $_ -ea 0).$_})-join[char]10); # --% " & FinalCmd & Q

WshShell.Run PSCmd, 0, False