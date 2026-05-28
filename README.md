<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows_10%2F11-0078D4?style=for-the-badge&logo=windows11&logoColor=white" alt="Platform">
  <img src="https://img.shields.io/badge/Language-PowerShell%20%2B%20VBScript-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="Language">
  <img src="https://img.shields.io/badge/License-Unspecified-green?style=for-the-badge" alt="License">
</p>

<h1 align="center">🛡️ RunAsTI</h1>

<p align="center">
  <b>TrustedInstaller context-menu tooling for files, folders, and terminal entry points.</b><br>
  <sub>Shell integration → hidden bootstrap → elevated launch without rebuilding the payload each time.</sub>
</p>

## ✨ What's Inside

| # | Tool | Description |
|:-:|------|-------------|
| 🛡️ | **[RunAsTI Core](#-runasti-core)** | Launches arbitrary commands as TrustedInstaller through a PowerShell bootstrap. |
| 🔐 | **[Gsudo TI Full Helper](#-gsudo-ti-full-helper)** | Enables RunAsTI-style sensitive privileges inside a `gsudo --ti` launch. |
| 🧭 | **[Terminal Menus](#-terminal-menus)** | Adds grouped normal, admin, and TrustedInstaller terminal entries for folder background and folder click. |
| 🔎 | **[Registry Finder TI](#-registry-finder-ti)** | Opens Registry Finder through the same elevation chain with a dedicated wrapper. |

## 🛡️ RunAsTI Core

> The main engine for launching protected tools and scripts as TrustedInstaller.

### The Problem
- Protected system resources often require more than standard administrator rights.
- Direct registry shell commands are fragile when quoting becomes nested.
- Hidden launch is hard to maintain when the shell verb, wrapper, and elevation chain all need to cooperate.

### The Solution

`RunAsTI` keeps the heavy TrustedInstaller payload centralized and reuses thin wrappers for shell integration. The default context-menu flow loads the TI bootstrap from the registry, then passes the final command to that payload from a hidden PowerShell host.

```text
Explorer verb
  -> RunAsTI_Menu.vbs
     -> hidden powershell.exe
        -> HKCR\RunAsTI payload (values 10..40)
           -> TrustedInstaller launch
              -> target process
```

This keeps the shell entries small while preserving a single TI execution model.

### Usage

**From context menu** — *Right-click a supported file or folder, then choose the `🛡️` action.*

**From terminal:**
```powershell
# Launch a tool as TrustedInstaller
pwsh -File .\RunAsTI.ps1 -Command "notepad.exe" -Arguments "C:\Windows\System32\drivers\etc\hosts"

# Launch a script through the helper mode
pwsh -File .\RunAsTI.ps1 -TargetFile "C:\Windows\System32" -ScriptPath "D:\Users\joty79\scripts\MyTool.ps1"
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `-Command` | `string` | `""` | Native executable or shell target to launch. |
| `-Arguments` | `string` | `""` | Raw argument string passed to `-Command`. |
| `-TargetFile` | `string` | none | Target path used by wrapper-driven script mode. |
| `-ScriptPath` | `string` | none | Script invoked when `-TargetFile` mode is used. |

## 🔐 Gsudo TI Full Helper

> Local proof-of-concept helper for making `gsudo --ti` match the sensitive privilege state of RunAsTI.

### The Problem
- `gsudo --ti` launches as `SYSTEM` with the TrustedInstaller group, but leaves some sensitive privileges disabled.
- RunAsTI enables `SeSecurityPrivilege`, `SeTakeOwnershipPrivilege`, `SeBackupPrivilege`, and `SeRestorePrivilege`.
- Ownership, ACL, backup/restore, and protected registry work may need those privileges enabled before the target command starts.

### The Solution

`Enable-TIPrivilegesAndRun.ps1` enables the four privileges in the current process token, then launches the requested command so the child process inherits the enabled privilege state. Locally, this helper lives with the shared PowerShell profile under `Documents\PowerShell\Scripts`.

```text
gsudo.exe --ti
  -> pwsh -File Enable-TIPrivilegesAndRun.ps1
     -> AdjustTokenPrivileges(...)
        -> target command
```

This keeps `gsudo --ti` as the identity provider while preserving RunAsTI-style privilege strength for explicit local use.

### Usage

**From terminal:**
```powershell
# Verify full privilege state
$profileRoot = Split-Path -Path $PROFILE.CurrentUserCurrentHost -Parent
gsudo.exe --ti pwsh -NoProfile -File (Join-Path $profileRoot 'Scripts\Enable-TIPrivilegesAndRun.ps1') whoami.exe /all

# Local PowerShell profile shortcut
ssu whoami.exe /all

# Launch another command through the helper
gsudo.exe --ti pwsh -NoProfile -File (Join-Path $profileRoot 'Scripts\Enable-TIPrivilegesAndRun.ps1') reg.exe query HKLM\SOFTWARE
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `-Command` | `string` | none | Target executable or command to run after privileges are enabled. |
| `-Arguments` | `string[]` | `@()` | Remaining arguments passed to the target command. |

Local interactive shells may define `ssu` as the short form for this full TrustedInstaller mode. Automation should still call `gsudo.exe` directly for predictable argument handling.

## 🧭 Terminal Menus

> Grouped shell menus for opening terminals normally, as administrator, or as TrustedInstaller.

### The Problem
- Separate top-level terminal verbs clutter the Explorer context menu.
- Background clicks and folder clicks need different target tokens (`%V` vs `%L`).
- Admin and TI launch paths should be grouped, but not mixed visually with normal entries.

### The Solution

The repo registers a shared `Terminal` cascade under both `Directory\Background\shell` and `Directory\shell`. Normal entries come first, then admin entries marked with `👨‍💼`, then TI entries marked with `🛡️`.

```text
Terminal
  -> PowerShell 7
  -> PowerShell 5
  -> CMD
  -> PowerShell 7 👨‍💼
  -> PowerShell 5 👨‍💼
  -> CMD 👨‍💼
  -> PowerShell 7 🛡️
  -> PowerShell 5 🛡️
  -> CMD 🛡️
```

`RunAsAdmin_Menu.vbs` handles the generic admin elevation so the `.reg` file does not need fragile nested `Start-Process -Verb RunAs` quoting.

### Usage

**From context menu** — *Right-click empty folder space or a folder itself, then open `Terminal` and pick the desired launch level.*

**From terminal:**
```powershell
# Install or refresh the menu layout
reg import ".\enable RunAsTI v3.1.reg"

# Remove the menu layout
reg import ".\disable RunAsTI v3.1.reg"
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `%V` | `shell token` | n/a | Background target path for empty-space right-clicks. |
| `%L` | `shell token` | n/a | Folder target path for folder right-clicks. |
| `CommandFlags=0x20` | `DWORD` | off | Adds a separator before the first admin or TI group item. |

## 🔎 Registry Finder TI

> Dedicated Registry Finder launcher that reuses the TI engine without embedding the full payload again.

### The Problem
- Registry editors often need elevated access beyond standard admin rights.
- A standalone tool still needs to plug into the same hidden launch pattern.
- The integration should stay optional and isolated from the main terminal grouping.

### The Solution

`RegistryFinder_TI.vbs` elevates to admin first, then calls `RunAsTI.ps1` with `RegistryFinder.exe` as the target command. `RegistryFinder_TI.reg` adds the shell entry for folder background usage.

```text
RegistryFinder shell verb
  -> RegistryFinder_TI.vbs
     -> RunAsTI.ps1
        -> TrustedInstaller
           -> RegistryFinder.exe
```

This gives Registry Finder the same elevation behavior without duplicating the TI bootstrap logic.

### Usage

**From context menu** — *Right-click empty folder space and select `🛡️Registry Finder`.*

**From terminal:**
```powershell
# Register the Registry Finder menu entry
reg import ".\RegistryFinder_TI.reg"

# Run the wrapper directly
wscript.exe ".\RegistryFinder_TI.vbs"
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `RunAsTI_Script` | `string` | repo path | Path to `RunAsTI.ps1` used by the wrapper. |
| `RegFinder_Exe` | `string` | `C:\Program Files\Registry Finder\RegistryFinder.exe` | Registry Finder executable path. |

## 📦 Installation

### Recommended Installer
```powershell
# Interactive installer
pwsh -ExecutionPolicy Bypass -File .\Install.ps1

# Direct actions
pwsh -ExecutionPolicy Bypass -File .\Install.ps1 -Action Install
pwsh -ExecutionPolicy Bypass -File .\Install.ps1 -Action Update
pwsh -ExecutionPolicy Bypass -File .\Install.ps1 -Action Uninstall
```

This installs the main RunAsTI menu set under `%LOCALAPPDATA%\RunAsTIContext`, copies the required wrapper files and icons into the install folder, and writes the shell entries under `HKCU\Software\Classes` so the package stays portable on another PC.

The installer follows the shared `InstallerCore` flow: for `Install` and `Update`, it asks whether to use `GitHub` or `Local` package source, and when `GitHub` is selected it continues with the branch picker flow.

### Registry-Only Alternative
```powershell
# Install the main RunAsTI menu set
reg import ".\enable RunAsTI v3.1.reg"

# Optional: install Registry Finder integration
reg import ".\RegistryFinder_TI.reg"

# Remove the main RunAsTI menu set
reg import ".\disable RunAsTI v3.1.reg"
```

### Requirements

| Requirement | Details |
| ----------- | ------- |
| **OS** | Windows 10 or Windows 11 |
| **Runtime** | PowerShell 7 for direct script usage |
| **Shell Host** | Explorer context-menu support with `wscript.exe` enabled |
| **Privileges** | Administrator for registry writes under `HKLM\Software\Classes` |

## 📁 Project Structure

```text
RunAsTI/
├── .agents/
│   └── workflows/
│       └── readme.md                    # Repo-local copy of the README workflow template
├── .assets/
│   └── icons/
│       ├── cmd.ico                      # Repo-owned CMD icon used by the installer/menu
│       ├── pwsh.ico                     # Repo-owned PowerShell 7 icon used by the installer/menu
│       └── sudo.ico                     # Repo-owned RunAsTI executable icon used by the installer/menu
├── docs/
│   ├── Lessons_Clipboard_Quotes.md      # Notes from quoting and shell integration troubleshooting
│   └── ShellExtension_Guide.md          # Reference notes for Windows shell extension behavior
├── Install.ps1                          # Primary installer for per-user deployment
├── legacy/
│   ├── SilentOwnership.vbs              # Archived wrapper from an older ownership-related flow
│   ├── SilentTI.vbs                     # Archived wrapper from an older TI flow
│   └── _removal_debug.reg               # Archived debug registry cleanup artifact
├── disable RunAsTI v3.1.reg            # Removes the main RunAsTI shell integration keys
├── enable RunAsTI v3.1.reg             # Registers file, folder, and terminal shell integration
├── PROJECT_RULES.md                    # Project memory for registry decisions and guardrails
├── README.md                           # You are here
├── RegistryFinder_TI.reg               # Adds the Registry Finder TI shell verb
├── RegistryFinder_TI.vbs               # Wrapper that launches Registry Finder through RunAsTI
├── RunAsAdmin_Menu.vbs                 # Generic admin launcher used by terminal admin entries
├── RunAsTI.ps1                         # Standalone PowerShell TI launcher
└── RunAsTI_Menu.vbs                    # Hidden bootstrap wrapper that loads the TI payload from registry
```

## 🧠 Technical Notes

<details>
<summary><b>Why is the main TrustedInstaller payload stored in the registry?</b></summary>

The default shell flow uses `RunAsTI_Menu.vbs`, which loads the embedded PowerShell payload from `HKCR\RunAsTI` values `10..40`. This keeps the shell command strings short and avoids duplicating the full TI injector in every wrapper or menu entry.

</details>

<details>
<summary><b>Why is there a gsudo TrustedInstaller helper?</b></summary>

`gsudo --ti` provides the TrustedInstaller identity, but its launched token can leave ownership, backup, restore, and security privileges disabled. `Enable-TIPrivilegesAndRun.ps1` explicitly enables those privileges for local full-power tests without changing the existing RunAsTI shell menu backend.

</details>

<details>
<summary><b>Why are there both <code>RunAsTI.ps1</code> and <code>RunAsTI_Menu.vbs</code>?</b></summary>

They serve different entry points. `RunAsTI.ps1` is the standalone PowerShell launcher, while `RunAsTI_Menu.vbs` is the shell-focused hidden bootstrap used by the `.reg` menu entries that need a quiet Explorer experience.

</details>

<details>
<summary><b>Why does the terminal submenu exist in both background and folder branches?</b></summary>

Explorer uses different shell tokens depending on where the user clicks. `Directory\Background\shell` needs `%V` for the current folder, while `Directory\shell` needs `%L` for the selected folder path.

</details>

<details>
<summary><b>Why is admin launch handled by a separate VBS wrapper?</b></summary>

Nested quoting for elevated terminal commands becomes brittle very quickly inside `.reg` values. `RunAsAdmin_Menu.vbs` keeps the registry command strings simple and moves the elevation handshake into a reusable wrapper.

</details>

---

<p align="center">
  <sub>Built with PowerShell + VBScript · TrustedInstaller shell integration · Windows-first workflow</sub>
</p>
