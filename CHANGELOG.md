# Changelog

## 2026-05-24

- Added and then moved `Enable-TIPrivilegesAndRun.ps1` to the shared PowerShell profile repo under `Documents\PowerShell\Scripts`; the helper runs inside `gsudo.exe --ti`, enables `SeSecurityPrivilege`, `SeTakeOwnershipPrivilege`, `SeBackupPrivilege`, and `SeRestorePrivilege`, then launches the requested command.
- Verified `gsudo.exe --ti pwsh -NoProfile -File .\Enable-TIPrivilegesAndRun.ps1 whoami.exe /all` shows the four RunAsTI-relevant privileges as `Enabled`.
- Added local PowerShell profile function `ssu` as the interactive shortcut for this full TrustedInstaller mode.
