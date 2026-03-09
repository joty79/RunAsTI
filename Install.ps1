#requires -version 7.0
[CmdletBinding()]
param(
    [ValidateSet('Install', 'Update', 'Uninstall', 'InstallGitHub', 'UpdateGitHub', 'OpenInstallDirectory', 'OpenInstallLogs', 'DownloadLatest')]
    [string]$Action = 'Install',
    [string]$InstallPath = '',
    [string]$SourcePath = $PSScriptRoot,
    [ValidateSet('Local', 'GitHub')]
    [string]$PackageSource = 'Local',
    [string]$GitHubRepo = '',
    [string]$GitHubRef = '',
    [string]$GitHubZipUrl = '',
    [switch]$Force,
    [switch]$NoExplorerRestart
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:ProfileJson = @'
{
  "tool_name": "RunAsTI",
  "installer_title": "RunAsTI Installer",
  "install_folder_name": "RunAsTIContext",
  "github_repo": "joty79/RunAsTI",
  "github_ref": "",
  "legacy_root": "D:\\Users\\joty79\\scripts\\RunAsTI",
  "publisher": "joty79",
  "uninstall_key_name": "RunAsTIContext",
  "uninstall_display_name": "RunAsTI Context Menu",
  "menu_option_5_label": "Open install logs",
  "required_commands": [
    "reg.exe"
  ],
  "required_package_entries": [
    "Install.ps1",
    "RunAsTI.ps1",
    "RunAsTI_Menu.vbs",
    "RunAsAdmin_Menu.vbs",
    "RegistryFinder_TI.vbs",
    "RegistryFinder_TI.reg",
    "enable RunAsTI v3.1.reg",
    "disable RunAsTI v3.1.reg",
    ".assets",
    ".assets\\icons\\cmd.ico",
    ".assets\\icons\\pwsh.ico",
    ".assets\\icons\\sudo.ico"
  ],
  "deploy_entries": [
    "Install.ps1",
    "RunAsTI.ps1",
    "RunAsTI_Menu.vbs",
    "RunAsAdmin_Menu.vbs",
    "RegistryFinder_TI.vbs",
    "RegistryFinder_TI.reg",
    "enable RunAsTI v3.1.reg",
    "disable RunAsTI v3.1.reg",
    ".assets"
  ],
  "preserve_existing_entries": [],
  "verify_core_files": [
    "Install.ps1",
    "RunAsTI.ps1",
    "RunAsTI_Menu.vbs",
    "RunAsAdmin_Menu.vbs",
    ".assets\\icons\\cmd.ico",
    ".assets\\icons\\pwsh.ico",
    ".assets\\icons\\sudo.ico"
  ],
  "migration_copy_entries": [
    "logs",
    "state"
  ],
  "uninstall_preserve_files": [
    "Install.ps1"
  ],
  "registry_cleanup_keys": [
    "HKCR\\RunAsTI",
    "HKCU\\Software\\Classes\\RunAsTI",
    "HKCR\\batfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI",
    "HKCR\\cmdfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI",
    "HKCR\\exefile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI",
    "HKCR\\mscfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI",
    "HKCR\\Microsoft.PowerShellScript.1\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI",
    "HKCR\\regfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI",
    "HKCR\\Folder\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI",
    "HKCR\\Directory\\shell\\RunAsTI_Terminal",
    "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
    "HKCR\\Directory\\background\\shell\\RunAsTI_Terminal",
    "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
    "HKCR\\Directory\\background\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI",
    "HKCR\\Directory\\background\\shell\\RunAsTI_PS5",
    "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_PS5",
    "HKCR\\Directory\\background\\shell\\RunAsTI_CMD",
    "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_CMD",
    "HKCU\\Software\\Classes\\Directory\\Background\\shell\\RunAsTI_Terminal",
    "HKCU\\Software\\Classes\\Directory\\Background\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\Directory\\Background\\shell\\RunAsTI_PS5",
    "HKCU\\Software\\Classes\\Directory\\Background\\shell\\RunAsTI_CMD",
    "HKCR\\JSFile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\JSFile\\shell\\RunAsTI",
    "HKCR\\VBSFile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\VBSFile\\shell\\RunAsTI",
    "HKCR\\WinRAR\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI",
    "HKCR\\CABFolder\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI",
    "HKCR\\Msi.Package\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI",
    "HKCR\\dllfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI",
    "HKCR\\inffile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI",
    "HKCR\\cplfile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI",
    "HKCR\\WSFFile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\WSFFile\\shell\\RunAsTI",
    "HKCR\\htafile\\shell\\RunAsTI",
    "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI"
  ],
  "registry_values": [
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\cmd.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\cmd.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\sudo.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "mmc.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell\" \"-NoExit -nop -c iex((gc -lit %L)-join[char]10)\""
    },
    {
      "key": "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Import as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "regedit.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"regedit.exe\" \"/s\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Open as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "shell32.dll,-16710"
    },
    {
      "key": "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"explorer.exe\" \"\\\"%L\\\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Open as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "shell32.dll,-16710"
    },
    {
      "key": "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"explorer.exe\" \"\\\"%L\\\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Install as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "msiexec.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"msiexec.exe\" \"/i\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "shell32.dll,-154"
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"regsvr32.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Install as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "imageres.dll,-67"
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-WindowStyle Hidden -Command \"\"& InfDefaultInstall.exe '%1'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "shell32.dll,-137"
    },
    {
      "key": "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"control.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI",
      "name": "Extended",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Run as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "mshta.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"mshta.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Open as 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI",
      "name": "HasLUAShield",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "shell32.dll,-4"
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI",
      "name": "AppliesTo",
      "type": "REG_SZ",
      "value": "NOT System.ParsingName:=\"::{645FF040-5081-101B-9F08-00AA002F954E}\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Terminal"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "Position",
      "type": "REG_SZ",
      "value": "Middle"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "SubCommands",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "pwsh.exe -NoExit -Command \"Set-Location -LiteralPath '%V'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "powershell.exe -NoExit -Command \"Set-Location -LiteralPath '%V'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\03_CMD",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\03_CMD",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\03_CMD\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "cmd.exe /k cd /d \"%V\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "CommandFlags",
      "type": "REG_DWORD",
      "value": "0x00000020"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%V\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "CommandFlags",
      "type": "REG_DWORD",
      "value": "0x00000020"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%V\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "Terminal"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
      "name": "SubCommands",
      "type": "REG_SZ",
      "value": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "pwsh.exe -NoExit -Command \"Set-Location -LiteralPath '%L'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "powershell.exe -NoExit -Command \"Set-Location -LiteralPath '%L'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\03_CMD",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\03_CMD",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\03_CMD\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "cmd.exe /k cd /d \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "CommandFlags",
      "type": "REG_DWORD",
      "value": "0x00000020"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD 👨‍💼"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%L\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 7 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "CommandFlags",
      "type": "REG_DWORD",
      "value": "0x00000020"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "PowerShell 5 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "powershell.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI",
      "name": "MUIVerb",
      "type": "REG_SZ",
      "value": "CMD 🛡️"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI",
      "name": "Icon",
      "type": "REG_SZ",
      "value": "cmd.exe,0"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI\\command",
      "name": "(default)",
      "type": "REG_SZ",
      "value": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%L\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "10",
      "type": "REG_SZ",
      "value": "function RunAsTI ($cmd,$arg) { $id='RunAsTI'; $key=\"Registry::HKU\\$(((whoami /user)-split' ')[-1])\\Volatile Environment\"; $code=@'"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "11",
      "type": "REG_SZ",
      "value": " $I=[int32]; $M=$I.module.gettype(\"System.Runtime.Interop`Services.Mar`shal\"); $P=$I.module.gettype(\"System.Int`Ptr\"); $S=[string]"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "12",
      "type": "REG_SZ",
      "value": " $D=@(); $T=@(); $DM=[AppDomain]::CurrentDomain.\"DefineDynami`cAssembly\"(1,1).\"DefineDynami`cModule\"(1); $Z=[uintptr]::size "
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "13",
      "type": "REG_SZ",
      "value": " 0..5|% {$D += $DM.\"Defin`eType\"(\"1337MAGIQ_$_\",1179913,[ValueType])}; $D += [uintptr]; 4..6|% {$D += $D[$_].\"MakeByR`efType\"()}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "14",
      "type": "REG_SZ",
      "value": " $F='kernel','advapi','advapi', ($S,$S,$I,$I,$I,$I,$I,$S,$D[7],$D[8]), ([uintptr],$S,$I,$I,$D[9]),([uintptr],$S,$I,$I,[byte[]],$I)"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "15",
      "type": "REG_SZ",
      "value": " 0..2|% {$9=$D[0].\"DefinePInvok`eMethod\"(('CreateProcess','RegOpenKeyEx','RegSetValueEx')[$_],$F[$_]+'32',8214,1,$S,$F[$_+3],1,4)}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "16",
      "type": "REG_SZ",
      "value": " $DF=($P,$I,$P),($I,$I,$I,$I,$P,$D[1]),($I,$S,$S,$S,$I,$I,$I,$I,$I,$I,$I,$I,[int16],[int16],$P,$P,$P,$P),($D[3],$P),($P,$P,$I,$I)"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "17",
      "type": "REG_SZ",
      "value": " 1..5|% {$k=$_; $n=1; $DF[$_-1]|% {$9=$D[$k].\"Defin`eField\"('f' + $n++, $_, 6)}}; 0..5|% {$T += $D[$_].\"Creat`eType\"()}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "18",
      "type": "REG_SZ",
      "value": " 0..5|% {nv \"A$_\" ([Activator]::CreateInstance($T[$_])) -fo}; function F ($1,$2) {$T[0].\"G`etMethod\"($1).invoke(0,$2)}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "19",
      "type": "REG_SZ",
      "value": " $TI=(whoami /groups)-like'*1-16-16384*'; $As=0; if(!$cmd) {$cmd='control';$arg='admintools'}; if ($cmd-eq'This PC'){$cmd='file:'}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "20",
      "type": "REG_SZ",
      "value": " if (!$TI) {'TrustedInstaller','lsass','winlogon'|% {if (!$As) {$9=sc.exe start $_; $As=@(get-process -name $_ -ea 0|% {$_})[0]}}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "21",
      "type": "REG_SZ",
      "value": " function M ($1,$2,$3) {$M.\"G`etMethod\"($1,[type[]]$2).invoke(0,$3)}; $H=@(); $Z,(4*$Z+16)|% {$H += M \"AllocHG`lobal\" $I $_}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "22",
      "type": "REG_SZ",
      "value": " M \"WriteInt`Ptr\" ($P,$P) ($H[0],$As.Handle); $A1.f1=131072; $A1.f2=$Z; $A1.f3=$H[0]; $A2.f1=1; $A2.f2=1; $A2.f3=1; $A2.f4=1"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "23",
      "type": "REG_SZ",
      "value": " $A2.f6=$A1; $A3.f1=10*$Z+32; $A4.f1=$A3; $A4.f2=$H[1]; M \"StructureTo`Ptr\" ($D[2],$P,[boolean]) (($A2 -as $D[2]),$A4.f2,$false)"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "24",
      "type": "REG_SZ",
      "value": " $Run=@($null, \"powershell -win Hidden -nop -c iex `$env:R; # $id\", 0, 0, 0, 0x0E080600, 0, $null, ($A4 -as $T[4]), ($A5 -as $T[5]))"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "25",
      "type": "REG_SZ",
      "value": " F 'CreateProcess' $Run; return}; $env:R=''; rp $key $id -force; $priv=[diagnostics.process].\"GetM`ember\"('SetPrivilege',42)[0]"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "26",
      "type": "REG_SZ",
      "value": " 'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege' |% {$priv.Invoke($null, @(\"$_\",2))}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "27",
      "type": "REG_SZ",
      "value": " $HKU=[uintptr][uint32]2147483651; $NT='S-1-5-18'; $reg=($HKU,$NT,8,2,($HKU -as $D[9])); F 'RegOpenKeyEx' $reg; $LNK=$reg[4]"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "28",
      "type": "REG_SZ",
      "value": " function L ($1,$2,$3) {sp 'Registry::HKCR\\AppID\\{CDCBCFCA-3CDC-436f-A4E2-0E02075250C2}' 'RunAs' $3 -force -ea 0"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "29",
      "type": "REG_SZ",
      "value": "  $b=[Text.Encoding]::Unicode.GetBytes(\"\\Registry\\User\\$1\"); F 'RegSetValueEx' @($2,'SymbolicLinkValue',0,6,[byte[]]$b,$b.Length)}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "30",
      "type": "REG_SZ",
      "value": " function Q {[int](gwmi win32_process -filter 'name=\"explorer.exe\"'|?{$_.getownersid().sid-eq$NT}|select -last 1).ProcessId}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "31",
      "type": "REG_SZ",
      "value": " $env:wt=if(gcm wt.exe -ea 0){'wt.exe \"-d .\"'}else{'powershell'}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "32",
      "type": "REG_SZ",
      "value": " $11bug=($((gwmi Win32_OperatingSystem).BuildNumber)-eq'22000')-AND(($cmd-eq'file:')-OR(test-path -lit $cmd -PathType Container))"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "33",
      "type": "REG_SZ",
      "value": " if ($11bug) {'System.Windows.Forms','Microsoft.VisualBasic' |% {$9=[Reflection.Assembly]::LoadWithPartialName(\"$_\")}}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "34",
      "type": "REG_SZ",
      "value": " if ($11bug) {$path='^(l)'+$($cmd -replace '([\\+\\^\\%\\~\\(\\)\\[\\]])','{$1}')+'{ENTER}'; $cmd='control.exe'; $arg='admintools'}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "35",
      "type": "REG_SZ",
      "value": " L ($key-split'\\\\')[1] $LNK ''; $R=[diagnostics.process]::start($cmd,$arg); if ($R) {$R.PriorityClass='High'; $R.WaitForExit()}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "36",
      "type": "REG_SZ",
      "value": " if ($11bug) {$w=0; do {if($w-gt40){break}; sleep -mi 250;$w++} until (Q); [Microsoft.VisualBasic.Interaction]::AppActivate($(Q))}"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "37",
      "type": "REG_SZ",
      "value": " if ($11bug) {[Windows.Forms.SendKeys]::SendWait($path)}; do {sleep 7} while(Q); L '.Default' $LNK 'Interactive User'"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "38",
      "type": "REG_SZ",
      "value": "'@; $V='';'cmd','arg','id','key'|%{$V+=\"`n`$$_='$($(gv $_ -val)-replace\"'\",\"''\")';\"}; sp $key $id $($V,$code) -type 7 -force -ea 0"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "39",
      "type": "REG_SZ",
      "value": " (New-Object -ComObject Shell.Application).ShellExecute(\"powershell\", \"-win Hidden -nop -c `n$V `$env:R=(gi `$key -ea 0).getvalue(`$id)-join''; iex `$env:R\", \"\", \"runas\", 0)"
    },
    {
      "key": "HKCU\\Software\\Classes\\RunAsTI",
      "name": "40",
      "type": "REG_SZ",
      "value": "}; $A=,([environment]::commandline-split'-[-]%+ ?',2)[1]-split'\"([^\"]+)\"|([^ ]+)',2|%{$_.Trim(' \"')}; RunAsTI $A[1] $A[2]; # 1337MAGIQ, 2025.11.16"
    }
  ],
  "registry_verify": [
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\cmd.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\batfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\cmd.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\cmdfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\sudo.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\exefile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\mscfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Microsoft.PowerShellScript.1\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell\" \"-NoExit -nop -c iex((gc -lit %L)-join[char]10)\""
    },
    {
      "key": "HKCU\\Software\\Classes\\regfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"regedit.exe\" \"/s\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\WinRAR\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"explorer.exe\" \"\\\"%L\\\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\CABFolder\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"explorer.exe\" \"\\\"%L\\\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Msi.Package\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"msiexec.exe\" \"/i\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\dllfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"regsvr32.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\inffile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-WindowStyle Hidden -Command \"\"& InfDefaultInstall.exe '%1'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\cplfile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"control.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\htafile\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"mshta.exe\" \"%1\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Folder\\shell\\RunAsTI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal",
      "name": "SubCommands",
      "expected": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7\\command",
      "name": "(default)",
      "expected": "pwsh.exe -NoExit -Command \"Set-Location -LiteralPath '%V'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5\\command",
      "name": "(default)",
      "expected": "powershell.exe -NoExit -Command \"Set-Location -LiteralPath '%V'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\03_CMD\\command",
      "name": "(default)",
      "expected": "cmd.exe /k cd /d \"%V\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%V\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%V'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\background\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%V\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal",
      "name": "SubCommands",
      "expected": ""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\01_PowerShell7\\command",
      "name": "(default)",
      "expected": "pwsh.exe -NoExit -Command \"Set-Location -LiteralPath '%L'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\02_PowerShell5\\command",
      "name": "(default)",
      "expected": "powershell.exe -NoExit -Command \"Set-Location -LiteralPath '%L'\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\03_CMD\\command",
      "name": "(default)",
      "expected": "cmd.exe /k cd /d \"%L\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\11_PowerShell7_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\12_PowerShell5_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\13_CMD_Admin\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsAdmin_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%L\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI",
      "name": "Icon",
      "expected": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\21_PowerShell7_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"pwsh.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\22_PowerShell5_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"powershell.exe\" \"-NoExit -Command \"\"Set-Location -LiteralPath '%L'\"\"\""
    },
    {
      "key": "HKCU\\Software\\Classes\\Directory\\shell\\RunAsTI_Terminal\\shell\\23_CMD_TI\\command",
      "name": "(default)",
      "expected": "wscript.exe \"{InstallRoot}\\RunAsTI_Menu.vbs\" \"cmd.exe\" \"/k cd /d \"%L\"\""
    }
  ],
  "wrapper_patches": [
    {
      "file": "RegistryFinder_TI.vbs",
      "regex": "RunAsTI_Script\\s*=\\s*\"[^\"]+\"",
      "replacement": "RunAsTI_Script = \"{InstallRoot}\\RunAsTI.ps1\""
    },
    {
      "file": "enable RunAsTI v3.1.reg",
      "regex": "D:\\\\Users\\\\joty79\\\\scripts\\\\RunAsTI\\\\RunAsTI_Menu\\.vbs",
      "replacement": "{InstallRoot}\\RunAsTI_Menu.vbs"
    },
    {
      "file": "enable RunAsTI v3.1.reg",
      "regex": "D:\\\\Users\\\\joty79\\\\scripts\\\\RunAsTI\\\\RunAsAdmin_Menu\\.vbs",
      "replacement": "{InstallRoot}\\RunAsAdmin_Menu.vbs"
    },
    {
      "file": "enable RunAsTI v3.1.reg",
      "regex": "d:\\\\Users\\\\joty79\\\\Documents\\\\Icons\\\\cmd\\.ico",
      "replacement": "{InstallRoot}\\.assets\\icons\\cmd.ico"
    },
    {
      "file": "enable RunAsTI v3.1.reg",
      "regex": "d:\\\\Users\\\\joty79\\\\Documents\\\\Icons\\\\pwsh\\.ico",
      "replacement": "{InstallRoot}\\.assets\\icons\\pwsh.ico"
    },
    {
      "file": "enable RunAsTI v3.1.reg",
      "regex": "d:\\\\Users\\\\joty79\\\\Documents\\\\Icons\\\\sudo\\.ico",
      "replacement": "{InstallRoot}\\.assets\\icons\\sudo.ico"
    },
    {
      "file": "RegistryFinder_TI.reg",
      "regex": "D:\\\\Users\\\\joty79\\\\scripts\\\\RunAsTI\\\\RegistryFinder_TI\\.vbs",
      "replacement": "{InstallRoot}\\RegistryFinder_TI.vbs"
    }
  ]
}
'@
$script:Profile = $script:ProfileJson | ConvertFrom-Json -Depth 50
$script:GitHubRefSpecified = $PSBoundParameters.ContainsKey('GitHubRef')

function Get-P([string]$Name, [object]$Default = $null) {
    $prop = $script:Profile.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $Default }
    return $prop.Value
}
function Arr([string]$Name) { @((Get-P $Name @()) | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) }
function Norm([string]$Path) { [System.IO.Path]::GetFullPath($Path.Trim()) }
function X([string]$Value, [string]$InstallRoot) {
    if ($null -eq $Value) { return '' }
    return $Value.Replace('{InstallRoot}', $InstallRoot).Replace('{InstallPath}', $InstallPath).Replace('{SourcePath}', $SourcePath)
}
function EnsureDir([string]$Path) { if (-not (Test-Path -LiteralPath $Path)) { New-Item -Path $Path -ItemType Directory -Force | Out-Null } }
function NormalizeGitHubRef([string]$Ref) {
    if ($null -eq $Ref) { return '' }
    $candidate = $Ref.Trim()
    if ($candidate.StartsWith('refs/heads/', [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidate = $candidate.Substring('refs/heads/'.Length)
    }
    return $candidate
}

$script:ToolName = [string](Get-P 'tool_name' 'Tool')
$script:InstallerVersion = '1.0.0'
$script:DisplayName = [string](Get-P 'uninstall_display_name' "$($script:ToolName) Context Menu")
$script:InstallerTitle = [string](Get-P 'installer_title' "$($script:ToolName) Installer")
$script:LegacyRoot = [string](Get-P 'legacy_root' '')
$uninstallKeyName = [string](Get-P 'uninstall_key_name' "$($script:ToolName)Context")
$script:UninstallKeyPath = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\$uninstallKeyName"
$script:Warnings = [System.Collections.Generic.List[string]]::new()
$script:ResolvedPackageSource = $PackageSource
$script:ResolvedGitHubCommit = ''
$script:TempPackageRoots = [System.Collections.Generic.List[string]]::new()
$script:HasCliArgs = $MyInvocation.BoundParameters.Count -gt 0

if ([string]::IsNullOrWhiteSpace($InstallPath)) { $InstallPath = Join-Path $env:LOCALAPPDATA ([string](Get-P 'install_folder_name' "$($script:ToolName)Context")) }
if ([string]::IsNullOrWhiteSpace($GitHubRepo)) { $GitHubRepo = [string](Get-P 'github_repo' '') }
$GitHubRef = NormalizeGitHubRef $GitHubRef
if (-not $script:GitHubRefSpecified) { $GitHubRef = NormalizeGitHubRef ([string](Get-P 'github_ref' '')) }
$InstallPath = Norm $InstallPath
$SourcePath = Norm $SourcePath
$script:InstallerLogPath = Join-Path $InstallPath 'logs\installer.log'

function Log([string]$Message, [ValidateSet('INFO', 'WARN', 'ERROR')] [string]$Level = 'INFO') {
    $line = ('{0} | {1} | {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'), $Level, $Message)
    try { EnsureDir (Split-Path -Path $script:InstallerLogPath -Parent); Add-Content -Path $script:InstallerLogPath -Value $line -Encoding UTF8 } catch {}
    if ($Level -eq 'WARN') { $script:Warnings.Add($Message) | Out-Null; Write-Host "[!] $Message" -ForegroundColor Yellow; return }
    if ($Level -eq 'ERROR') { Write-Host "[x] $Message" -ForegroundColor Red; return }
    Write-Host "[>] $Message" -ForegroundColor DarkGray
}

function RequiredEntries {
    $r = Arr 'required_package_entries'
    if ($r.Count -gt 0) { return $r }
    return (Arr 'deploy_entries')
}
function DeployEntries {
    $r = Arr 'deploy_entries'
    if ($r.Count -gt 0) { return $r }
    return (RequiredEntries)
}

function Confirm([string]$Prompt) {
    if ($Force) { return $true }
    return ((Read-Host "$Prompt [y/N]").Trim().ToLowerInvariant() -eq 'y')
}

function RegCmd([AllowEmptyString()][string[]]$RegArgs, [switch]$IgnoreNotFound) {
    $out = & reg.exe @RegArgs 2>&1
    if ($LASTEXITCODE -eq 0) { return $out }
    $text = ($out | Out-String).Trim()
    if ($IgnoreNotFound -and $text -match 'unable to find the specified registry key or value') { return $null }
    throw "reg.exe failed: reg $($RegArgs -join ' ')`n$text"
}
function RegDel([string]$Key) { RegCmd -RegArgs @('delete', $Key, '/f') -IgnoreNotFound | Out-Null }
function RegAdd([string]$Key, [string]$Name, [string]$Type, [AllowEmptyString()][string]$Value) {
    $safe = if ($Type -eq 'REG_DWORD') { if ([string]::IsNullOrWhiteSpace($Value)) { '0' } else { $Value } } else { $Value }
    $regArgs = @('add', $Key)
    if ($Name -eq '(default)') { $regArgs += '/ve' } else { $regArgs += @('/v', $Name) }
    $regArgs += @('/t', $Type, '/d', $safe, '/f')
    RegCmd -RegArgs $regArgs | Out-Null
    if ($Type -in @('REG_SZ', 'REG_EXPAND_SZ') -and $Value -eq '') {
        $actual = RegGet -Key $Key -Name $Name
        if ($null -eq $actual -or $actual -ne '') {
            throw "Empty-string registry write verification failed for $Key [$Name]"
        }
    }
}
function RegGet([string]$Key, [string]$Name) {
    $q = if ($Name -eq '(default)') { RegCmd -RegArgs @('query', $Key, '/ve') -IgnoreNotFound } else { RegCmd -RegArgs @('query', $Key, '/v', $Name) -IgnoreNotFound }
    if (-not $q) { return $null }
    $line = $q | Where-Object { $_ -match 'REG_' -and $_ -match '^\s*(\(Default\)|\S+)\s+REG_' } | Select-Object -First 1
    if (-not $line) { return $null }
    $parts = ($line -split '\s{2,}') | Where-Object { $_ -ne '' }
    if ($parts.Count -ge 3) { return [string]$parts[2] }
    return ''
}

function CleanupRegistry {
    foreach ($k in (Arr 'registry_cleanup_keys')) {
        try {
            RegDel $k
        }
        catch {
            $errText = [string]$_.Exception.Message
            if ($k -like 'HKCR\*' -and $errText -match 'Access is denied') { continue }
            Log "Failed to remove key: $k" 'WARN'
        }
    }
}
function WriteRegistry([string]$InstallRoot) {
    CleanupRegistry
    foreach ($row in @((Get-P 'registry_values' @()))) {
        $k = [string]$row.key; if ([string]::IsNullOrWhiteSpace($k)) { continue }
        $n = [string]$row.name; if ([string]::IsNullOrWhiteSpace($n)) { $n = '(default)' }
        $t = [string]$row.type; if ([string]::IsNullOrWhiteSpace($t)) { $t = 'REG_SZ' }
        $v = X ([string]$row.value) $InstallRoot
        RegAdd -Key $k -Name $n -Type $t -Value $v
    }
}
function VerifyRegistry([string]$InstallRoot) {
    $ok = $true
    foreach ($row in @((Get-P 'registry_verify' @()))) {
        $k = [string]$row.key; $n = [string]$row.name; if ([string]::IsNullOrWhiteSpace($n)) { $n = '(default)' }
        $e = X ([string]$row.expected) $InstallRoot
        $a = RegGet -Key $k -Name $n
        if ($a -ne $e) { $ok = $false; Log "Registry mismatch: $k [$n] expected='$e' actual='$a'" 'WARN' }
    }
    return $ok
}

function SetUninstall([string]$InstallRoot) {
    $installScript = Join-Path $InstallRoot 'Install.ps1'
    $uninstallCmd = "pwsh -NoProfile -ExecutionPolicy Bypass -File `"$installScript`" -Action Uninstall -Force"
    $publisher = [string](Get-P 'publisher' 'joty79')
    New-Item -Path $script:UninstallKeyPath -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'DisplayName' -PropertyType String -Value $script:DisplayName -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'DisplayVersion' -PropertyType String -Value $script:InstallerVersion -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'Publisher' -PropertyType String -Value $publisher -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'InstallLocation' -PropertyType String -Value $InstallRoot -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'UninstallString' -PropertyType String -Value $uninstallCmd -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'NoModify' -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty -Path $script:UninstallKeyPath -Name 'NoRepair' -PropertyType DWord -Value 1 -Force | Out-Null
}
function RemoveUninstall {
    try { if (Test-Path -LiteralPath $script:UninstallKeyPath) { Remove-Item -LiteralPath $script:UninstallKeyPath -Recurse -Force } } catch { Log 'Could not remove uninstall registry entry.' 'WARN' }
}

function TestPkgRoot([string]$Root) { foreach ($e in (RequiredEntries)) { if (-not (Test-Path -LiteralPath (Join-Path $Root $e))) { return $false } }; return $true }
function Get-GitHubApiHeaders {
    $headers = @{ 'User-Agent' = "$($script:ToolName)Installer/$($script:InstallerVersion)" }
    if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
        $headers['Authorization'] = "Bearer $($env:GITHUB_TOKEN)"
    }
    return $headers
}
function Get-GitHubRemoteInfo([string]$Repo) {
    $result = [ordered]@{
        DefaultBranch = ''
        Branches = [System.Collections.Generic.List[string]]::new()
    }
    if ([string]::IsNullOrWhiteSpace($Repo)) { return [pscustomobject]$result }

    if (Get-Command gh.exe -ErrorAction SilentlyContinue) {
        try {
            $repoJson = (& gh.exe api "repos/$Repo" 2>$null | Out-String).Trim()
            if (-not [string]::IsNullOrWhiteSpace($repoJson)) {
                $repoInfo = $repoJson | ConvertFrom-Json
                $result.DefaultBranch = [string]$repoInfo.default_branch
            }
            $branchesJson = (& gh.exe api --paginate "repos/$Repo/branches?per_page=100" 2>$null | Out-String).Trim()
            if (-not [string]::IsNullOrWhiteSpace($branchesJson)) {
                foreach ($row in @($branchesJson | ConvertFrom-Json)) {
                    $name = NormalizeGitHubRef ([string]$row.name)
                    if (-not [string]::IsNullOrWhiteSpace($name) -and -not $result.Branches.Contains($name)) {
                        $result.Branches.Add($name)
                    }
                }
            }
            if ($result.DefaultBranch -or $result.Branches.Count -gt 0) { return [pscustomobject]$result }
        }
        catch {}
    }

    try {
        $headers = Get-GitHubApiHeaders
        $repoResp = Invoke-WebRequest -Uri ("https://api.github.com/repos/{0}" -f $Repo) -UseBasicParsing -Headers $headers
        $repoInfo = $repoResp.Content | ConvertFrom-Json
        $result.DefaultBranch = [string]$repoInfo.default_branch

        $branchesResp = Invoke-WebRequest -Uri ("https://api.github.com/repos/{0}/branches?per_page=100" -f $Repo) -UseBasicParsing -Headers $headers
        foreach ($row in @($branchesResp.Content | ConvertFrom-Json)) {
            $name = NormalizeGitHubRef ([string]$row.name)
            if (-not [string]::IsNullOrWhiteSpace($name) -and -not $result.Branches.Contains($name)) {
                $result.Branches.Add($name)
            }
        }
    }
    catch {}

    return [pscustomobject]$result
}
function ResolveGitHubRefAuto {
    if ($script:GitHubRefSpecified -and -not [string]::IsNullOrWhiteSpace($GitHubRef)) {
        $script:ResolvedGitHubCommit = ''
        return $GitHubRef
    }

    $info = Get-GitHubRemoteInfo -Repo $GitHubRepo
    $preferred = [System.Collections.Generic.List[string]]::new()
    foreach ($candidate in @($info.DefaultBranch, 'master', [string](Get-P 'github_ref' ''), 'latest')) {
        $name = NormalizeGitHubRef $candidate
        if (-not [string]::IsNullOrWhiteSpace($name) -and -not $preferred.Contains($name)) {
            $preferred.Add($name)
        }
    }

    foreach ($candidate in $preferred) {
        if ($info.Branches.Contains($candidate)) {
            Log "Auto-detected GitHub ref: $candidate"
            return $candidate
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($info.DefaultBranch)) {
        $defaultRef = NormalizeGitHubRef $info.DefaultBranch
        if (-not [string]::IsNullOrWhiteSpace($defaultRef)) {
            Log "Falling back to remote default branch: $defaultRef" 'WARN'
            return $defaultRef
        }
    }

    foreach ($candidate in @('master', 'latest')) {
        if (-not [string]::IsNullOrWhiteSpace($candidate)) {
            Log "GitHub ref auto-detect failed; using fallback ref: $candidate" 'WARN'
            return $candidate
        }
    }

    throw 'Could not resolve a GitHub ref.'
}
function EnsureGitHubRefResolved {
    $resolved = ResolveGitHubRefAuto
    $script:GitHubRefSpecified = $true
    $script:ResolvedGitHubCommit = ''
    Set-Variable -Name GitHubRef -Scope Script -Value $resolved
}
function ResolveSourceRoot {
    $script:ResolvedPackageSource = $PackageSource
    if ($PackageSource -eq 'Local' -and (TestPkgRoot $SourcePath)) { return $SourcePath }
    if ([string]::IsNullOrWhiteSpace($GitHubRepo)) { throw 'GitHubRepo is required for GitHub package source.' }
    if ([string]::IsNullOrWhiteSpace($GitHubRef)) { EnsureGitHubRefResolved }
    if ([string]::IsNullOrWhiteSpace($GitHubRef)) { throw 'GitHubRef could not be resolved for GitHub package source.' }
    $script:ResolvedPackageSource = 'GitHub'
    $fallbackRoots = @()
    if (TestPkgRoot $SourcePath) { $fallbackRoots += $SourcePath }
    if ((Test-Path -LiteralPath $InstallPath) -and (TestPkgRoot $InstallPath)) { $fallbackRoots += $InstallPath }
    $url = if ([string]::IsNullOrWhiteSpace($GitHubZipUrl)) { "https://codeload.github.com/$GitHubRepo/zip/refs/heads/$GitHubRef" } else { $GitHubZipUrl.Trim() }
    $tmp = Join-Path $env:TEMP ("$($script:ToolName)_pkg_" + [guid]::NewGuid().ToString('N'))
    $zip = Join-Path $tmp 'pkg.zip'
    $ext = Join-Path $tmp 'extract'
    EnsureDir $tmp; EnsureDir $ext
    $script:TempPackageRoots.Add($tmp) | Out-Null
    Log "Downloading package: $url"
    $downloaded = $false
    try {
        $headers = @{ 'User-Agent' = "$($script:ToolName)Installer/$($script:InstallerVersion)" }
        if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
            $headers['Authorization'] = "Bearer $($env:GITHUB_TOKEN)"
        }
        Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing -Headers $headers
        $downloaded = $true
    }
    catch {
        if (Get-Command gh.exe -ErrorAction SilentlyContinue) {
            try {
                Log 'Invoke-WebRequest failed; trying authenticated GitHub API fallback via gh auth token...'
                $ghToken = (& gh.exe auth token 2>$null | Out-String).Trim()
                if (-not [string]::IsNullOrWhiteSpace($ghToken)) {
                    $apiHeaders = @{
                        'User-Agent' = "$($script:ToolName)Installer/$($script:InstallerVersion)"
                        'Authorization' = "Bearer $ghToken"
                        'Accept' = 'application/vnd.github+json'
                    }
                    $apiUrl = "https://api.github.com/repos/$GitHubRepo/zipball/$GitHubRef"
                    Invoke-WebRequest -Uri $apiUrl -OutFile $zip -UseBasicParsing -Headers $apiHeaders
                }
                if (Test-Path -LiteralPath $zip) {
                    $downloaded = $true
                }
            }
            catch {}
        }
        if (-not $downloaded) {
            if ($fallbackRoots.Count -gt 0) {
                Log "GitHub fetch failed. Falling back to local package source: $($fallbackRoots[0])" 'WARN'
                $script:ResolvedPackageSource = 'Local'
                return $fallbackRoots[0]
            }
            throw
        }
    }
    try {
        Expand-Archive -Path $zip -DestinationPath $ext -Force
    }
    catch {
        if ($fallbackRoots.Count -gt 0) {
            Log "GitHub extract failed. Falling back to local package source: $($fallbackRoots[0])" 'WARN'
            $script:ResolvedPackageSource = 'Local'
            return $fallbackRoots[0]
        }
        throw
    }
    $roots = @(Get-ChildItem -LiteralPath $ext -Directory -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
    foreach ($r in $roots) { if (TestPkgRoot $r) { return $r } }
    if ($fallbackRoots.Count -gt 0) {
        Log "Downloaded package missing required files. Falling back to local package source: $($fallbackRoots[0])" 'WARN'
        $script:ResolvedPackageSource = 'Local'
        return $fallbackRoots[0]
    }
    throw 'Downloaded package does not contain required files.'
}

function Deploy([string]$SourceRoot, [string]$InstallRoot) {
    $keep = @{}; foreach ($e in (Arr 'preserve_existing_entries')) { $keep[$e.ToLowerInvariant()] = $true }
    foreach ($rel in (DeployEntries)) {
        $src = Join-Path $SourceRoot $rel
        $dst = Join-Path $InstallRoot $rel
        if (-not (Test-Path -LiteralPath $src)) { throw "Missing deploy entry: $rel" }
        $preserve = $keep.ContainsKey($rel.ToLowerInvariant())
        $srcItem = Get-Item -LiteralPath $src
        if ($srcItem.PSIsContainer) {
            if ($preserve -and (Test-Path -LiteralPath $dst)) { continue }
            EnsureDir (Split-Path -Path $dst -Parent)
            Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force
            continue
        }
        EnsureDir (Split-Path -Path $dst -Parent)
        if ($preserve -and (Test-Path -LiteralPath $dst)) { continue }
        if ((Norm $src) -ieq (Norm $dst)) { continue }
        Copy-Item -LiteralPath $src -Destination $dst -Force
    }
}

function PatchWrappers([string]$InstallRoot) {
    foreach ($p in @((Get-P 'wrapper_patches' @()))) {
        $fileRel = [string]$p.file; $regex = [string]$p.regex; $repRaw = [string]$p.replacement
        if ([string]::IsNullOrWhiteSpace($fileRel) -or [string]::IsNullOrWhiteSpace($regex)) { continue }
        $target = Join-Path $InstallRoot $fileRel
        if (-not (Test-Path -LiteralPath $target)) { Log "Wrapper patch target missing: $target" 'WARN'; continue }
        $raw = Get-Content -LiteralPath $target -Raw
        $patched = [regex]::Replace($raw, $regex, (X $repRaw $InstallRoot))
        Set-Content -LiteralPath $target -Value $patched -Encoding UTF8
    }
}

function VerifyCore([string]$InstallRoot) {
    $required = Arr 'verify_core_files'; if ($required.Count -eq 0) { $required = RequiredEntries }
    $ok = $true
    foreach ($rel in $required) {
        if (-not (Test-Path -LiteralPath (Join-Path $InstallRoot $rel))) { $ok = $false; Log "Missing core file: $rel" 'WARN' }
    }
    return $ok
}

function SaveMeta([string]$InstallRoot, [string]$Mode) {
    $metaPath = Join-Path $InstallRoot 'state\install-meta.json'
    EnsureDir (Split-Path -Path $metaPath -Parent)
    $meta = [ordered]@{
        schema_version = 1
        installer_version = $script:InstallerVersion
        tool_name = $script:ToolName
        install_path = $InstallPath
        source_path = if ($script:ResolvedPackageSource -eq 'GitHub') { "github://$GitHubRepo@$GitHubRef" } else { $SourcePath }
        package_source = $script:ResolvedPackageSource
        github_repo = $GitHubRepo
        github_ref = $GitHubRef
        github_zip_url = $GitHubZipUrl
        github_commit = $script:ResolvedGitHubCommit
        last_action = $Mode
        installed_utc = (Get-Date).ToUniversalTime().ToString('o')
    }
    $meta | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $metaPath -Encoding UTF8
}

function Resolve-ExplorerPathArgument([string]$PathToUse) {
    if ([string]::IsNullOrWhiteSpace($PathToUse)) { return '' }

    try {
        $fullPath = [System.IO.Path]::GetFullPath($PathToUse)
    }
    catch {
        return ''
    }

    if (-not (Test-Path -LiteralPath $fullPath -PathType Container)) { return '' }

    $desktopPath = [Environment]::GetFolderPath('Desktop')
    if ($fullPath.TrimEnd('\') -ieq $desktopPath.TrimEnd('\')) { return '' }

    return $fullPath
}

function Get-ExplorerRestartPath {
    foreach ($candidate in @($SourcePath, $InstallPath)) {
        $resolved = Resolve-ExplorerPathArgument -PathToUse $candidate
        if (-not [string]::IsNullOrWhiteSpace($resolved)) { return $resolved }
    }
    return ''
}

function RestartExplorer {
    if ($NoExplorerRestart) { Log 'Explorer restart skipped by -NoExplorerRestart.' 'WARN'; return }
    if (-not $Force) {
        $a = (Read-Host 'Restart Explorer now to refresh context menus? [Y/n]').Trim().ToLowerInvariant()
        if ($a -in @('n', 'no')) { Log 'Explorer restart skipped by user.' 'WARN'; return }
    }

    $reopenPath = Get-ExplorerRestartPath
    $runningExplorer = @(Get-Process -Name explorer -ErrorAction SilentlyContinue)

    try {
        foreach ($process in $runningExplorer) {
            try {
                Stop-Process -Id $process.Id -Force -ErrorAction Stop
            }
            catch {}
        }
        try {
            Wait-Process -Name explorer -Timeout 5 -ErrorAction SilentlyContinue
        }
        catch {}

        # Do not Start-Process explorer.exe here. Windows auto-restores the shell,
        # and forcing a new explorer process can create a secondary zombie instance.
        $shellAlive = $false
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        do {
            Start-Sleep -Milliseconds 300
            if (Get-Process -Name explorer -ErrorAction SilentlyContinue) { $shellAlive = $true }
        } while (-not $shellAlive -and $sw.Elapsed.TotalSeconds -lt 10)

        if (-not $shellAlive) {
            Log 'Explorer shell did not auto-restart within timeout. Please restart manually.' 'WARN'
            return
        }

        if ([string]::IsNullOrWhiteSpace($reopenPath)) {
            Start-Sleep -Milliseconds 500
            Log 'Explorer restarted (auto). No folder window was reopened.'
            return
        }

        Start-Sleep -Seconds 2
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Open($reopenPath)
            Log "Explorer restarted and reopened folder: $reopenPath"
        }
        catch {
            Log "Explorer restarted, but folder reopen failed: $reopenPath" 'WARN'
        }
    }
    catch {
        Log 'Explorer restart failed. Please restart manually.' 'WARN'
    }
}

function RunInstallOrUpdate([ValidateSet('Install', 'Update')] [string]$Mode) {
    Log "Starting $Mode to $InstallPath"
    foreach ($cmd in @('pwsh.exe', 'wscript.exe') + (Arr 'required_commands')) { if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { Log "Missing required command: $cmd" 'ERROR'; return 1 } }
    EnsureDir $InstallPath; EnsureDir (Join-Path $InstallPath 'logs'); EnsureDir (Join-Path $InstallPath 'state'); EnsureDir (Join-Path $InstallPath 'assets')
    try { $src = ResolveSourceRoot; Deploy -SourceRoot $src -InstallRoot $InstallPath } finally { foreach ($t in $script:TempPackageRoots) { try { if (Test-Path -LiteralPath $t) { Remove-Item -LiteralPath $t -Recurse -Force -ErrorAction SilentlyContinue } } catch {} } $script:TempPackageRoots.Clear() }
    PatchWrappers -InstallRoot $InstallPath
    $coreOk = VerifyCore -InstallRoot $InstallPath
    WriteRegistry -InstallRoot $InstallPath
    $regOk = VerifyRegistry -InstallRoot $InstallPath
    SetUninstall -InstallRoot $InstallPath
    SaveMeta -InstallRoot $InstallPath -Mode $Mode
    RestartExplorer
    if ($script:Warnings.Count -gt 0 -or -not $coreOk -or -not $regOk) { Write-Host "$Mode completed with warnings." -ForegroundColor Yellow; return 2 }
    Write-Host "$Mode completed successfully." -ForegroundColor Green
    return 0
}

function RunUninstall {
    Log "Starting uninstall from $InstallPath"
    CleanupRegistry
    RemoveUninstall
    if (Test-Path -LiteralPath $InstallPath) {
        $preserve = @('Install.ps1') + (Arr 'uninstall_preserve_files')
        foreach ($item in @(Get-ChildItem -LiteralPath $InstallPath -Force -ErrorAction SilentlyContinue)) {
            if ($preserve -contains $item.Name) { continue }
            try { Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction Stop } catch { Log "Could not remove during uninstall: $($item.FullName)" 'WARN' }
        }
    }
    RestartExplorer
    Write-Host 'Uninstall completed successfully.' -ForegroundColor Green
    return 0
}

function CleanupTempPackageRoots {
    foreach ($tempRoot in $script:TempPackageRoots) {
        try {
            if (Test-Path -LiteralPath $tempRoot) {
                Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        catch {}
    }
    $script:TempPackageRoots.Clear()
}

function Start-RelaunchUpdatedInstaller([string]$TargetRoot) {
    $updatedInstaller = Join-Path $TargetRoot 'Install.ps1'
    if (-not (Test-Path -LiteralPath $updatedInstaller)) {
        throw "Updated installer was not found after download: $updatedInstaller"
    }

    $pwshCmd = Get-Command pwsh.exe -ErrorAction SilentlyContinue
    $pwshExe = if ($null -ne $pwshCmd) { $pwshCmd.Source } else { Join-Path $PSHOME 'pwsh.exe' }
    $launcherPath = Join-Path $env:TEMP ("{0}_relaunch_{1}.cmd" -f $script:ToolName, [guid]::NewGuid().ToString('N'))
    $launcherContent = @(
        '@echo off',
        'setlocal',
        'timeout /t 2 /nobreak >nul',
        ('start "" "{0}" -ExecutionPolicy Bypass -File "{1}"' -f $pwshExe, $updatedInstaller),
        'del "%~f0"'
    )
    Set-Content -LiteralPath $launcherPath -Value $launcherContent -Encoding ASCII
    Start-Process -FilePath $launcherPath -WindowStyle Hidden | Out-Null
}

function RunDownloadLatest {
    $targetRoot = Norm $PSScriptRoot
    Log "Starting DownloadLatest to $targetRoot"

    if (-not (Get-Command pwsh.exe -ErrorAction SilentlyContinue)) {
        Log 'Missing required command: pwsh.exe' 'ERROR'
        return 1
    }

    $originalSourcePath = $SourcePath
    $originalPackageSource = $PackageSource
    try {
        $PackageSource = 'GitHub'
        Set-Variable -Name PackageSource -Scope Script -Value 'GitHub'
        $SourcePath = $targetRoot
        Set-Variable -Name SourcePath -Scope Script -Value $targetRoot

        EnsureGitHubRefResolved
        if (-not $script:HasCliArgs) {
            $GitHubRef = ReadRefInteractive -DefaultRef $GitHubRef
            Set-Variable -Name GitHubRef -Scope Script -Value $GitHubRef
        }
        Write-Host ("Using GitHub ref: {0}" -f $GitHubRef) -ForegroundColor DarkCyan

        $src = ResolveSourceRoot
        if ($script:ResolvedPackageSource -ne 'GitHub') {
            throw 'GitHub download failed. DownloadLatest does not allow local fallback.'
        }

        Deploy -SourceRoot $src -InstallRoot $targetRoot
        $coreOk = VerifyCore -InstallRoot $targetRoot
        if (-not $coreOk) {
            Write-Host 'Download Latest completed with warnings.' -ForegroundColor Yellow
            return 2
        }

        Start-RelaunchUpdatedInstaller -TargetRoot $targetRoot
        Write-Host 'Latest files downloaded successfully. Relaunching updated installer...' -ForegroundColor Green
        return 0
    }
    finally {
        Set-Variable -Name SourcePath -Scope Script -Value $originalSourcePath
        Set-Variable -Name PackageSource -Scope Script -Value $originalPackageSource
        CleanupTempPackageRoots
    }
}

function ShowMenu {
    while ($true) {
        try { Clear-Host } catch {}
        Write-Host '============================================================' -ForegroundColor Cyan
        Write-Host ('  {0}  v{1}' -f $script:InstallerTitle, $script:InstallerVersion) -ForegroundColor Cyan
        Write-Host '============================================================' -ForegroundColor Cyan
        Write-Host ('Source:  {0}' -f $SourcePath) -ForegroundColor DarkGray
        Write-Host ('Install: {0}' -f $InstallPath) -ForegroundColor DarkGray
        Write-Host ''
        Write-Host '[1] Install' -ForegroundColor Green
        Write-Host '[2] Update' -ForegroundColor Yellow
        Write-Host '[3] Uninstall' -ForegroundColor Red
        Write-Host '[4] Download Latest here' -ForegroundColor Green
        Write-Host '[5] Open install directory' -ForegroundColor Cyan
        Write-Host ('[6] {0}' -f ([string](Get-P 'menu_option_5_label' 'Open install logs'))) -ForegroundColor Cyan
        Write-Host '[0] Exit' -ForegroundColor Gray
        $c = (Read-Host 'Select option').Trim()
        switch ($c) { '1' { return 'Install' }; '2' { return 'Update' }; '3' { return 'Uninstall' }; '4' { return 'DownloadLatest' }; '5' { return 'OpenInstallDirectory' }; '6' { return 'OpenInstallLogs' }; '0' { return 'Exit' } }
    }
}

function Get-GitHubBranchNames([string]$Repo) {
    if ([string]::IsNullOrWhiteSpace($Repo)) { return @() }

    $headers = @{ 'User-Agent' = "$($script:ToolName)Installer/$($script:InstallerVersion)" }
    if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
        $headers['Authorization'] = "Bearer $($env:GITHUB_TOKEN)"
    }

    try {
        $resp = Invoke-RestMethod -Uri ("https://api.github.com/repos/{0}/branches?per_page=100" -f $Repo) -Headers $headers -Method Get
        if (-not $resp) { return @() }
        $names = @($resp | ForEach-Object { [string]$_.name } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        return @($names | Select-Object -Unique)
    }
    catch {
        if (Get-Command gh.exe -ErrorAction SilentlyContinue) {
            try {
                $ghToken = (& gh.exe auth token 2>$null | Out-String).Trim()
                if (-not [string]::IsNullOrWhiteSpace($ghToken)) {
                    $authHeaders = @{
                        'User-Agent' = "$($script:ToolName)Installer/$($script:InstallerVersion)"
                        'Authorization' = "Bearer $ghToken"
                        'Accept' = 'application/vnd.github+json'
                    }
                    $resp = Invoke-RestMethod -Uri ("https://api.github.com/repos/{0}/branches?per_page=100" -f $Repo) -Headers $authHeaders -Method Get
                    if ($resp) {
                        $names = @($resp | ForEach-Object { [string]$_.name } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
                        return @($names | Select-Object -Unique)
                    }
                }
            }
            catch {}
        }
        Write-Host ("[!] Could not fetch branch list from GitHub: {0}" -f $_.Exception.Message) -ForegroundColor Yellow
        return @()
    }
}

function ReadRefInteractive([string]$DefaultRef) {
    $normalizedDefault = if ([string]::IsNullOrWhiteSpace($DefaultRef)) { 'master' } else { $DefaultRef.Trim() }
    $branches = @(Get-GitHubBranchNames -Repo $GitHubRepo)

    if ($branches.Count -gt 0) {
        if ($branches -notcontains $normalizedDefault) {
            $branches = @($normalizedDefault) + @($branches)
        }
        else {
            $branches = @($normalizedDefault) + @($branches | Where-Object { $_ -ne $normalizedDefault })
        }
        $branches = @($branches | Select-Object -Unique)

        Write-Host ''
        Write-Host ("Available branches for {0}:" -f $GitHubRepo) -ForegroundColor Cyan
        for ($i = 0; $i -lt $branches.Count; $i++) {
            $n = $i + 1
            $name = $branches[$i]
            $suffix = if ($name -eq $normalizedDefault) { ' (default)' } else { '' }
            Write-Host ("[{0}] {1}{2}" -f $n, $name, $suffix) -ForegroundColor Gray
        }
        Write-Host '[Enter] Use default' -ForegroundColor Gray

        while ($true) {
            $choice = (Read-Host ("Select branch number (blank = {0})" -f $normalizedDefault)).Trim()
            if ([string]::IsNullOrWhiteSpace($choice)) { return $normalizedDefault }
            if ($choice -match '^\d+$') {
                $index = [int]$choice
                if ($index -ge 1 -and $index -le $branches.Count) {
                    return $branches[$index - 1]
                }
            }
            Write-Host 'Invalid selection. Choose a number or Enter.' -ForegroundColor Yellow
        }
    }

    Write-Host ("Could not read branch list. Using default ref: {0}" -f $normalizedDefault) -ForegroundColor Yellow
    return $normalizedDefault
}

function ReadPackageSourceInteractive([ValidateSet('Install', 'Update')] [string]$Mode, [ValidateSet('Local', 'GitHub')] [string]$DefaultSource = 'GitHub') {
    $defaultLabel = if ($DefaultSource -eq 'GitHub') { 'GitHub' } else { 'Local' }
    Write-Host ''
    Write-Host ("Package source for {0}:" -f $Mode) -ForegroundColor Cyan
    Write-Host ("[1] GitHub{0}" -f $(if ($DefaultSource -eq 'GitHub') { ' (default)' } else { '' })) -ForegroundColor Gray
    Write-Host ("[2] Local{0}" -f $(if ($DefaultSource -eq 'Local') { ' (default)' } else { '' })) -ForegroundColor Gray

    while ($true) {
        $choice = (Read-Host ("Select package source (blank = {0})" -f $defaultLabel)).Trim()
        if ([string]::IsNullOrWhiteSpace($choice)) { return $DefaultSource }
        switch ($choice) {
            '1' { return 'GitHub' }
            '2' { return 'Local' }
            default { Write-Host 'Invalid selection. Choose 1, 2, or Enter.' -ForegroundColor Yellow }
        }
    }
}

function PreparePackageSource([ValidateSet('Install', 'Update')] [string]$Mode) {
    if (-not $script:HasCliArgs) {
        $defaultSource = if ($PackageSource -eq 'Local') { 'GitHub' } else { $PackageSource }
        $PackageSource = ReadPackageSourceInteractive -Mode $Mode -DefaultSource $defaultSource
        Set-Variable -Name PackageSource -Scope Script -Value $PackageSource
    }

    if ($PackageSource -eq 'GitHub') {
        EnsureGitHubRefResolved
        if (-not $script:HasCliArgs) {
            $GitHubRef = ReadRefInteractive -DefaultRef $GitHubRef
            Set-Variable -Name GitHubRef -Scope Script -Value $GitHubRef
        }
        Write-Host ("Using GitHub ref: {0}" -f $GitHubRef) -ForegroundColor DarkCyan
        return
    }

    Write-Host ("Using local source: {0}" -f $SourcePath) -ForegroundColor DarkCyan
}

if (-not $script:HasCliArgs) { $menuAction = ShowMenu; if ($menuAction -eq 'Exit') { exit 0 }; $Action = $menuAction }
switch ($Action) {
    'Install' { PreparePackageSource -Mode 'Install'; if (-not (Confirm "Install $($script:DisplayName) to '$InstallPath'?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunInstallOrUpdate -Mode 'Install') }
    'InstallGitHub' { $PackageSource = 'GitHub'; EnsureGitHubRefResolved; Write-Host ("Using GitHub ref: {0}" -f $GitHubRef) -ForegroundColor DarkCyan; if (-not (Confirm "Install $($script:DisplayName) to '$InstallPath'?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunInstallOrUpdate -Mode 'Install') }
    'Update' { PreparePackageSource -Mode 'Update'; if (-not (Confirm "Update existing $($script:DisplayName) at '$InstallPath'?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunInstallOrUpdate -Mode 'Update') }
    'UpdateGitHub' { $PackageSource = 'GitHub'; EnsureGitHubRefResolved; Write-Host ("Using GitHub ref: {0}" -f $GitHubRef) -ForegroundColor DarkCyan; if (-not (Confirm "Update existing $($script:DisplayName) at '$InstallPath'?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunInstallOrUpdate -Mode 'Update') }
    'Uninstall' { if (-not (Confirm "Uninstall $($script:DisplayName) from '$InstallPath'?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunUninstall) }
    'DownloadLatest' { if (-not (Confirm "Download latest $($script:DisplayName) into '$PSScriptRoot' and relaunch the updated installer?")) { Write-Host 'Cancelled.' -ForegroundColor Yellow; exit 0 }; exit (RunDownloadLatest) }
    'OpenInstallDirectory' { if (-not (Test-Path -LiteralPath $InstallPath)) { Write-Host ("Install directory not found: {0}" -f $InstallPath) -ForegroundColor Yellow; exit 1 }; Start-Process explorer.exe -ArgumentList $InstallPath; exit 0 }
    'OpenInstallLogs' { $logFile = Join-Path $InstallPath 'logs\\installer.log'; $logDir = Split-Path -Path $logFile -Parent; EnsureDir $logDir; if (Test-Path -LiteralPath $logFile) { Start-Process notepad.exe -ArgumentList $logFile } else { Start-Process explorer.exe -ArgumentList $logDir }; exit 0 }
    default { Write-Host "Unknown action: $Action" -ForegroundColor Red; exit 1 }
}

