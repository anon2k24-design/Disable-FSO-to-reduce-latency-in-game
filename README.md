DONATE HERE: https://www.paypal.com/donate/?business=UNP6WN3E95EAL&no_recurring=0&item_name=unemployment+fund+pls&currency_code=USD

Disable Fullscreen Optimizations (FSO) Globally for Windows
A simple tool to disable Windows Fullscreen Optimizations globally via registry, eliminating the need to manually disable FSO for each game executable.

🚀 What This Does
Disables Fullscreen Optimizations (FSO) system-wide by setting the following registry values:

Registry Key	Value	Purpose
GameDVR_FSEBehaviorMode	2	FSO Disabled globally
GameDVR_Enabled	0	Game DVR completely disabled
GameDVR_HonorUserFSEBehaviorMode	1	Respects per-app compatibility settings
GameDVR_DXGIHonorFSEWindowsCompatible	1	Forces FSE behavior
AllowGameDVR	0	Blocks GameDVR at policy level
✨ Benefits
Better FPS in fullscreen games (especially Apex Legends, Fortnite, FPS titles)

Lower input latency

No more darting/windowing issues when alt-tabbing

One-time setup — no need to disable FSO per-exe for each game

📥 How to Use
Option 1: Registry File (Recommended)
Download disable_fso_global.reg

Double-click the file

Click Yes to confirm registry changes

Click OK to complete

Restart your computer

Option 2: PowerShell Script (Admin Required)
Download disable_fso_global.ps1

Open Windows PowerShell as Administrator

Run:

powershell
.\disable_fso_global.ps1
Restart your computer

✅ Verify It Worked
Open PowerShell and run:

powershell
Get-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode"
If it returns 2, FSO is disabled globally.

Or via regedit:

Press Win + R, type regedit

Navigate to: HKEY_CURRENT_USER\System\GameConfigStore

Confirm GameDVR_FSEBehaviorMode = 2

⚠️ Notes
Restart required for changes to fully apply

Some Steam titles may still require per-exe disable (Compatibility tab → "Disable fullscreen optimizations")

This will disable Color Management in Exclusive Fullscreen mode
