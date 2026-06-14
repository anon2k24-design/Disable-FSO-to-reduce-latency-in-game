# ============================================================================
# Disable Fullscreen Optimizations Globally - PowerShell Script
# ============================================================================
# Disables common Windows fullscreen optimization and Game DVR related settings.
#
# Support this project:
#   PayPal: https://www.paypal.com/donate/?business=UNP6WN3E95EAL&currency_code=USD
#   GitHub: https://github.com/anon2k24-design
# ============================================================================

Write-Host "Disabling Fullscreen Optimizations (FSO) Globally..." -ForegroundColor Cyan
Write-Host ""

$registryPath = "HKCU:\System\GameConfigStore"
$policyPath   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Created registry key: $registryPath" -ForegroundColor Yellow
}

$settings = @{
    "GameDVR_FSEBehaviorMode"               = 2
    "GameDVR_HonorUserFSEBehaviorMode"      = 1
    "GameDVR_DXGIHonorFSEWindowsCompatible" = 1
    "GameDVR_Enabled"                       = 0
}

foreach ($key in $settings.Keys) {
    New-ItemProperty -Path $registryPath -Name $key -PropertyType DWord -Value $settings[$key] -Force | Out-Null
    Write-Host "Set $key = $($settings[$key])" -ForegroundColor Green
}

if (-not (Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
    Write-Host "Created policy key: $policyPath" -ForegroundColor Yellow
}

New-ItemProperty -Path $policyPath -Name "AllowGameDVR" -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "Set AllowGameDVR = 0 (machine policy)" -ForegroundColor Green

Write-Host ""
Write-Host "SUCCESS! Fullscreen Optimizations / Game DVR settings updated." -ForegroundColor Green
Write-Host "Restart or sign out and sign back in for all changes to apply." -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to exit"