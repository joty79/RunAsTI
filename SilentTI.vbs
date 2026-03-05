Set WshShell = CreateObject("WScript.Shell")
' Η διαδρομή για το RunAsTI.cmd σου
RunAsTI = "D:\Users\joty79\scripts\Atlas\RunAsTI.cmd"

' Έλεγχος αν δόθηκε όρισμα (π.χ. regedit)
If WScript.Arguments.Count = 0 Then
    WScript.Quit
End If

' Εντολή: Τρέξε το RunAsTI + το Πρόγραμμα, κρυφά (0)
Command = "cmd /c " & Chr(34) & RunAsTI & Chr(34) & " " & WScript.Arguments(0)
WshShell.Run Command, 0, False