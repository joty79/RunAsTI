# PROJECT_RULES - RunAsTI

## Scope
- Repo root: `D:\Users\joty79\scripts\RunAsTI`
- Focus: TrustedInstaller context-menu integration via `.reg`, `.vbs`, `.ps1`.

## Guardrails
- Keep working `command` strings unchanged unless explicitly requested.
- Prefer structural menu changes over quoting rewrites.
- For `Directory\Background\shell` grouping, use nested `shell\...` child keys.
- Keep `enable`/`disable` registry artifacts mirrored for cleanup reliability.

## Decision Log

### 2026-03-05 - Background Terminal Grouping
- Date: 2026-03-05
- Problem: Background context menu TI entries are scattered (`PowerShell 7`, `PowerShell 5`, `CMD` as separate top-level items).
- Root cause: Flat registry structure under `Directory\background\shell`.
- Guardrail/rule: Group TI terminal verbs under one parent `Terminal` menu while preserving existing working command payloads.
- Files affected: `enable RunAsTI v3.1.reg`, `disable RunAsTI v3.1.reg`
- Validation/tests run: Static registry artifact review.

### 2026-03-05 - Terminal Cascade Not Expanding
- Date: 2026-03-05
- Problem: `Terminal 🛡️` appeared as a clickable item but did not open submenu.
- Root cause: Parent key `HKCR\Directory\Background\shell\RunAsTI_Terminal` missed `SubCommands=""` for this context.
- Guardrail/rule: For `Directory\Background\shell` cascades, keep nested `shell\...` child keys and set `SubCommands=""` on the parent when Explorer does not expand.
- Files affected: `enable RunAsTI v3.1.reg`, `disable RunAsTI v3.1.reg`, `PROJECT_RULES.md`
- Validation/tests run: `reg query HKCR\Directory\Background\shell\RunAsTI_Terminal /s`; live write/readback of `SubCommands` via `HKCU\Software\Classes`.

### 2026-03-05 - Shield Placement In Terminal Menus
- Date: 2026-03-05
- Problem: The shield icon/text marker on the parent `Terminal` menu would block a clean split between normal terminals and TI terminals.
- Root cause: TI marker was placed on the parent cascade instead of the child TI verbs.
- Guardrail/rule: Keep the parent menu generic (`Terminal`) and place `🛡️` only on submenu items that actually launch via RunAsTI.
- Files affected: `enable RunAsTI v3.1.reg`, `PROJECT_RULES.md`
- Validation/tests run: Static registry artifact review.

### 2026-03-05 - Mixed Terminal Submenu
- Date: 2026-03-05
- Problem: The `Terminal` submenu needed both normal and RunAsTI launch variants for the same shells.
- Root cause: The first grouped version only exposed TI entries.
- Guardrail/rule: In `Terminal`, list normal entries first, then TI entries with `🛡️`; use `CommandFlags=0x20` on the first TI child to render a separator.
- Files affected: `enable RunAsTI v3.1.reg`, `PROJECT_RULES.md`
- Validation/tests run: Static registry artifact review.

### 2026-03-05 - Terminal Ordering With Admin Group
- Date: 2026-03-05
- Problem: Background terminal actions needed a clearer progression: normal first, then admin, then RunAsTI.
- Root cause: The existing grouped layout had only normal and TI variants, with no separate admin launch path.
- Guardrail/rule: In `Directory\Background\shell\RunAsTI_Terminal`, keep ordering as normal -> admin `👨‍💼` -> TI `🛡️`; use `CommandFlags=0x20` on the first child of each new group; keep `PowerShell 7 👨‍💼` as a separate top-level entry outside the submenu.
- Files affected: `enable RunAsTI v3.1.reg`, `disable RunAsTI v3.1.reg`, `RunAsAdmin_Menu.vbs`, `PROJECT_RULES.md`
- Validation/tests run: Static registry artifact review.

### 2026-03-05 - Admin Launch Wrapper
- Date: 2026-03-05
- Problem: Admin background commands needed elevation without embedding complex `Start-Process -Verb RunAs` quoting directly into `.reg` strings.
- Root cause: Nested registry quoting for elevated shell launch is fragile and hard to maintain.
- Guardrail/rule: Use a dedicated `.vbs` wrapper for generic admin launch and keep `.reg` command strings simple.
- Files affected: `RunAsAdmin_Menu.vbs`, `enable RunAsTI v3.1.reg`, `PROJECT_RULES.md`
- Validation/tests run: Static VBS review; registry artifact review.

### 2026-03-05 - Terminal Submenu For Folder Context
- Date: 2026-03-05
- Problem: The `Terminal` grouping existed only for `Directory\Background\shell`, and `PowerShell 7 👨‍💼` was split out as a separate top-level background verb.
- Root cause: The first admin design optimized for visual proximity to `Open in Terminal` instead of keeping all terminal actions together and reusable on folder clicks.
- Guardrail/rule: Keep all custom terminal variants inside the `Terminal` submenu and mirror the same submenu under both `Directory\Background\shell` and `Directory\shell`; use `%V` for background and `%L` for folder targets.
- Files affected: `enable RunAsTI v3.1.reg`, `disable RunAsTI v3.1.reg`, `PROJECT_RULES.md`
- Validation/tests run: Static registry artifact review.

### 2026-03-06 - HKLM Leftover Menu Keys
- Date: 2026-03-06
- Problem: `Open in PowerShell 7 👨‍💼` remained visible after the new submenu layout moved that action inside `Terminal`.
- Root cause: The old verb still existed under `HKLM\Software\Classes\Directory\Background\shell\RunAsAdmin_PowerShell7`, so the merged `HKCR` view kept exposing it even after the `HKCU` variant was removed.
- Guardrail/rule: When retiring or renaming shell verbs, verify and clean both user-level and machine-wide branches; if Explorer still shows an old item, inspect `HKLM\Software\Classes\...` in addition to `HKCU\Software\Classes\...`.
- Files affected: `PROJECT_RULES.md`
- Validation/tests run: `reg query HKCR\Directory\Background\shell\RunAsAdmin_PowerShell7 /s`; `reg query HKLM\Software\Classes\Directory\Background\shell\RunAsAdmin_PowerShell7 /s`; elevated `reg delete`.

### 2026-03-09 - Self-Contained Installer Assets
- Date: 2026-03-09
- Problem: The repo had no installer and the menu assets still depended on external machine-local icon paths such as `D:\Users\joty79\Documents\Icons\*.ico`.
- Root cause: The original `.reg` artifacts and wrappers were authored against one dev machine path instead of a deployable install root.
- Guardrail/rule: Keep imported runtime icons inside `.assets\icons` and treat `Install.ps1` as the primary install path. `RunAsTI` must use the shared `InstallerCore` template-generated installer, not a bespoke installer flow. The generated install must deploy the repo-owned assets, patch installed wrappers/`.reg` artifacts to the deployed install root, and write the main RunAsTI menu set under `HKCU\Software\Classes` for per-user portability.
- Files affected: `.assets\icons\cmd.ico`, `.assets\icons\pwsh.ico`, `.assets\icons\sudo.ico`, `Install.ps1`, `RegistryFinder_TI.vbs`, `README.md`, `PROJECT_RULES.md`
- Validation/tests run: Replaced ad-hoc `Install.ps1` with template-generated installer from `InstallerCore`; PowerShell parser validation passed on `Install.ps1`; static checks confirmed `Local/GitHub` package-source chooser, branch picker functions, and `{InstallRoot}\.assets\icons\...` references in the generated installer.
