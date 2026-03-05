# 🔵 Windows Context Menu - Dynamic Shift Handling (Shell Extension)

This guide documents how to create a custom Shell Extension using **C#** and **SharpShell** to dynamically swap context menu entries based on the **Shift** key state.

---

## 🔸 Concept
- **Normal Right-Click**: Only "Run as Administrator" (👨‍💼) is visible.
- **Shift + Right-Click**: Only "Run as TrustedInstaller" (🛡️) is visible.

---

## 🔸 Prerequisites
1. **Visual Studio Community** (with .NET Desktop Development workload).
2. **SharpShell Library** (Available via NuGet).
3. **.NET Framework 4.8** (Target framework).

---

## 🔸 The Code Implementation

Create a new **Class Library (.NET Framework)** project and implement the following:

```csharp
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using SharpShell.Attributes;
using SharpShell.SharpContextMenu;
using System.Diagnostics;

[ComVisible(true)]
[COMServerAssociation(AssociationType.AllFiles)]
[COMServerAssociation(AssociationType.Directory)]
public class DynamicRunAsMenu : SharpContextMenu
{
    protected override bool CanShowMenu()
    {
        // Always show the handler, logic inside CreateMenu decides content
        return true;
    }

    protected override ContextMenuStrip CreateMenu()
    {
        var menu = new ContextMenuStrip();
        
        // 🔵 Check for Shift Key
        bool shiftPressed = (Control.ModifierKeys & Keys.Shift) != 0;
        
        if (shiftPressed)
        {
            // 🛡️ Option 1: TrustedInstaller (Visible ONLY with Shift)
            var itemTI = new ToolStripMenuItem("Run as 🛡️", null, (s, e) => LaunchTI());
            menu.Items.Add(itemTI);
        }
        else
        {
            // 👨‍💼 Option 2: Administrator (Visible ONLY WITHOUT Shift)
            var itemAdmin = new ToolStripMenuItem("Run as 👨‍💼", null, (s, e) => LaunchAdmin());
            menu.Items.Add(itemAdmin);
        }
        
        return menu;
    }

    private void LaunchAdmin()
    {
        foreach (var path in SelectedItemPaths)
        {
            ProcessStartInfo psi = new ProcessStartInfo
            {
                FileName = path,
                Verb = "runas",
                UseShellExecute = true
            };
            Process.Start(psi);
        }
    }

    private void LaunchTI()
    {
        string runAsTI_Path = @"D:\Users\joty79\scripts\RunAsTI\RunAsTI.ps1";
        foreach (var path in SelectedItemPaths)
        {
            // Call our Universal RunAsTI.ps1
            string args = $"-NoProfile -ExecutionPolicy Bypass -File \"{runAsTI_Path}\" -Command \"{path}\"";
            Process.Start("pwsh.exe", args);
        }
    }
}
```

---

## 🔸 Deployment Steps

1. **Sign the Assembly**: Go to Project Properties -> Signing -> Sign the assembly (generate a new `.snk` file).
2. **Register the DLL**:
   - Use `ServerRegistrationManager.exe` (part of SharpShell) or `regasm.exe`.
   - Command: `srm.exe install YourLibrary.dll -codebase`
3. **Restart Explorer**: Kill `explorer.exe` and restart it to load the extension.

---

## 🔸 Why this works
Unlike standard Registry entries (which can only *add* items with the `Extended` key), a **Shell Extension** runs code at the moment of the click. It can query the system state (ModifierKeys) and decide exactly which items to return to the Explorer menu, allowing for the "Swap" behavior you requested.

---
*Created per USER request for future reference.*
