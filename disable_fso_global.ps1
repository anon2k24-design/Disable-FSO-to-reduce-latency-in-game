# Disable Fullscreen Optimizations Globally - PowerShell Script
# Run this script as Administrator

Write-Host "Disabling Fullscreen Optimizations (FSO) Globally..."
Write-Host ""

# Define registry path
$registryPath = "HKCU:\System\GameConfigStore"

# Create registry key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Created registry key: $registryPath" -ForegroundColor Yellow
}

# Set registry values for disabling FSO
$settings = @{
    "GameDVR_FSEBehaviorMode" = 2
    "GameDVR_Enabled" = 0
    "GameDVR_HonorUserFSEBehaviorMode" = 1
    "GameDVR_DXGIHonorFSEWindowsCompatible" = 1
}

foreach ($key in $settings.Keys) {
    Set-ItemProperty -Path $registryPath -Name $key -Value $settings[$key] -Force | Out-Null
    Write-Host "Set $key = $($settings[$key])" -ForegroundColor Green
}

# Disable GameDVR at policy level
$policyPath = "HKCU:\SOFTWARE\Microsoft\PolicyManager\Default\ApplicationManagement"
if (-not (Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
}
Set-ItemProperty -Path $policyPath -Name "AllowGameDVR" -Value 0 -Force | Out-Null
Write-Host "Set AllowGameDVR = 0 (policy level)" -ForegroundColor Green

Write-Host ""
Write-Host "SUCCESS! Fullscreen Optimizations disabled globally." -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEP: Restart your computer for changes to apply." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")