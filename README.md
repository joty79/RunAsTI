# 🔵 RunAsTI - Universal TrustedInstaller Execution

This system allows you to run **any command or script** with **TrustedInstaller** privileges silently (no console flashes).

---

## 📁 File Structure

```
D:\Users\joty79\scripts\
├── RunAsTI\
│   ├── RunAsTI.ps1          ← Core universal script (NEVER modify this)
│   └── README.md            ← This guide
│
└── Utilities\
    └── TakeOwnership\       ← Example implementation
        ├── SilentOwnership.vbs   ← Wrapper that calls RunAsTI.ps1
        ├── Manage_Ownership.ps1  ← The actual ownership script
        └── Manage_Ownership.reg  ← Registry for context menu
```

---

## 🔧 How It Works

```
[Context Menu] → [VBS Wrapper] → [RunAsTI.ps1] → [TrustedInstaller] → [Your Script]
```

1. **Registry** calls the VBS wrapper with `%1` (the file path)
2. **VBS Wrapper** elevates to Admin and calls `RunAsTI.ps1`
3. **RunAsTI.ps1** elevates to TrustedInstaller and runs your script
4. **Your Script** runs with full TrustedInstaller privileges

---

## 🔵 Usage Methods

### Method 1: Universal Mode (Command Line)

Run any command as TrustedInstaller:

```powershell
# Run notepad as TI
.\RunAsTI.ps1 -Command "notepad" -Arguments "C:\Windows\System32\drivers\etc\hosts"

# Run PowerShell script as TI
.\RunAsTI.ps1 -Command "pwsh" -Arguments "-File C:\Scripts\MyScript.ps1 -Param1 Value"

# Run registry import as TI
.\RunAsTI.ps1 -Command "regedit" -Arguments "/s C:\Changes.reg"

# Delete protected file as TI
.\RunAsTI.ps1 -Command "cmd" -Arguments "/c del C:\Windows\System32\ProtectedFile.dll"
```

### Method 2: Smart Mode (For VBS Context Menus)

When calling from VBScript, use `-TargetFile` and `-ScriptPath` to avoid quoting issues:

```powershell
.\RunAsTI.ps1 -TargetFile "C:\Path\To\Target" -ScriptPath "C:\Path\To\YourScript.ps1"
```

This internally converts to:

```
Command: pwsh
Arguments: -NoProfile -ExecutionPolicy Bypass -File "YourScript.ps1" -TargetFile "Target"
```

---

## 📝 Creating a New Context Menu (Step by Step)

### Step 1: Create Your PowerShell Script

Create your script that will run as TrustedInstaller. It must accept `-TargetFile` parameter:

```powershell
# D:\Scripts\MyNewScript.ps1
param(
    [string]$TargetFile
)

# Your code here - runs as TrustedInstaller!
Write-Host "Processing: $TargetFile"
# ... do stuff with TI privileges ...
```

### Step 2: Create the VBS Wrapper

Create a VBS file that wraps your script:

```vbscript
' D:\Scripts\MyNewScript.vbs
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

' 🔵 Paths (CHANGE THESE!)
RunAsTI_Script = "D:\Users\joty79\scripts\RunAsTI\RunAsTI.ps1"
MyScript       = "D:\Scripts\MyNewScript.ps1"   ' <-- YOUR SCRIPT PATH

' 🔵 Calls RunAsTI.ps1 with -TargetFile AND -ScriptPath
TargetArgs = "-TargetFile " & Quote & TargetFile & Quote & " -ScriptPath " & Quote & MyScript & Quote

PsCmd = "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File " & Quote & RunAsTI_Script & Quote & " " & TargetArgs

Command = "pwsh " & PsCmd

WshShell.Run Command, 0, False
```

### Step 3: Create the Registry Entry

Create a `.reg` file:

```reg
Windows Registry Editor Version 5.00

; For Files
[HKEY_CLASSES_ROOT\*\shell\MyNewAction]
@="My New Action"
"Icon"="imageres.dll,-5324"

[HKEY_CLASSES_ROOT\*\shell\MyNewAction\command]
@="wscript.exe \"D:\\Scripts\\MyNewScript.vbs\" \"%1\""

; For Folders (optional)
[HKEY_CLASSES_ROOT\Directory\shell\MyNewAction]
@="My New Action"
"Icon"="imageres.dll,-5324"

[HKEY_CLASSES_ROOT\Directory\shell\MyNewAction\command]
@="wscript.exe \"D:\\Scripts\\MyNewScript.vbs\" \"%1\""
```

### Step 4: Import and Test

1. Double-click the `.reg` file to import
2. Right-click any file → "My New Action"
3. Your script runs as TrustedInstaller! 🎉

---

## 🔵 Debugging

Both scripts have built-in debug logging (disabled by default).

### Enable Debug in RunAsTI.ps1

Open `RunAsTI.ps1` and change line 26:

```powershell
$DebugMode = $true   # Was $false
```

This creates `debug_ps1.txt` in the RunAsTI folder.

### Enable Debug in VBS

In your VBS wrapper, add near the end:

```vbscript
' 🔵 Debug (Set to True to enable)
Const DebugMode = True

If DebugMode Then
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set logFile = fso.CreateTextFile("D:\Scripts\debug_vbs.txt", True)
    logFile.WriteLine "TimeStamp: " & Now
    logFile.WriteLine "TargetFile: " & TargetFile
    logFile.WriteLine "FullCommand: " & Command
    logFile.Close
End If
```

---

## ⚠️ Common Issues

### Problem: Nothing happens when clicking context menu

**Solution:** Enable debug logging in VBS to see the command being generated.

### Problem: VBS runs but PowerShell doesn't start

**Solution:** Check for syntax errors in RunAsTI.ps1. Look for stray `<` or `>` characters.

### Problem: UAC prompt appears but script doesn't run

**Solution:** The script path might have spaces. Ensure all paths are properly quoted.

### Problem: "Mandatory parameter missing" error

**Solution:** Ensure `-Command` parameter is set to `Mandatory=$false` in RunAsTI.ps1.

---

## 🔵 RunAsTI.ps1 Parameters

| Parameter     | Required | Description                                            |
| ------------- | -------- | ------------------------------------------------------ |
| `-Command`    | No*      | The executable to run (e.g., `pwsh`, `notepad`, `cmd`) |
| `-Arguments`  | No       | Arguments to pass to the command                       |
| `-TargetFile` | No*      | The target file path (from context menu)               |
| `-ScriptPath` | No*      | The PowerShell script to run                           |

*Either `-Command` OR both `-TargetFile` AND `-ScriptPath` must be provided.

---

## 💡 Tips

1. **Keep RunAsTI.ps1 in one central location** - Never copy it to each project
2. **Always use the VBS wrapper for context menus** - Direct PowerShell calls from registry cause flashes
3. **Test from command line first** before creating context menu
4. **Use `-ScriptPath` mode** from VBS to avoid quoting nightmares
5. **Back up your working setup** before making changes

---

## 📚 Credits

- Original RunAsTI concept by **AveYo** (LeanAndMean project)
- Ported to pure PowerShell for silent execution
- Universal wrapper system for context menu integration

---

*Last Updated: 2026-02-01*
