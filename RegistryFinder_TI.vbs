' 🔵 Registry Finder as TrustedInstaller
' Launches Registry Finder with TI privileges from folder background context menu

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
    objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 0
    WScript.Quit
End If

' 🔵 Main Logic
Quote = Chr(34)

' 🔵 Paths
RunAsTI_Script = Replace(WScript.ScriptFullName, WScript.ScriptName, "RunAsTI.ps1")
RegFinder_Exe  = "C:\Program Files\Registry Finder\RegistryFinder.exe"

' 🔵 Call RunAsTI.ps1 in Universal mode
' No arguments needed - just launch the app
PsCmd = "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File " & Quote & RunAsTI_Script & Quote & " -Command " & Quote & RegFinder_Exe & Quote

Command = "pwsh " & PsCmd

WshShell.Run Command, 0, False
