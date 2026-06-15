# ============================================================================
# Disable Fullscreen Optimizations Globally - PowerShell Script v2
# ============================================================================
# Disables common Windows fullscreen optimization and Game DVR related settings.
#
# Support this project:
#   PayPal: https://www.paypal.com/donate/?business=UNP6WN3E95EAL&currency_code=USD
#   GitHub: https://github.com/anon2k24-design
#   Sponsor: https://github.com/sponsors/anon2k24-design
# ============================================================================

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run this script as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$registryPath = "HKCU:\System\GameConfigStore"
$policyPath   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
$logPath      = ".\disable-fso-global-log.csv"
$revertPath   = ".\disable-fso-global-revert.ps1"
$changeLog    = @()

function Add-Change {
    param($Type, $Path, $Name, $OldValue, $NewValue)

    $script:changeLog += [PSCustomObject]@{
        Timestamp = Get-Date
        Type      = $Type
        Path      = $Path
        Name      = $Name
        OldValue  = $OldValue
        NewValue  = $NewValue
    }

    try {
        $script:changeLog | Export-Csv $logPath -NoTypeInformation -Encoding UTF8
    } catch {}
}

function Ensure-RegistryPath {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
}

function Get-RegistryValueSafe {
    param(
        [string]$Path,
        [string]$Name
    )
    try {
        return (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop).$Name
    } catch {
        return $null
    }
}

function Set-DwordSafe {
    param(
        [string]$Path,
        [string]$Name,
        [int]$Value
    )

    Ensure-RegistryPath -Path $Path
    $oldValue = Get-RegistryValueSafe -Path $Path -Name $Name
    New-ItemProperty -Path $Path -Name $Name -PropertyType DWord -Value $Value -Force | Out-Null
    Add-Change -Type "Registry" -Path $Path -Name $Name -OldValue $oldValue -NewValue $Value
    Write-Host "Set $Name = $Value" -ForegroundColor Green
}

function Write-RevertScript {
    $lines = @()
    $lines += '# Auto-generated revert script for Disable FSO Global v2'
    $lines += '$ErrorActionPreference = "SilentlyContinue"'
    $lines += 'Write-Host "Reverting Fullscreen Optimization / Game DVR changes..." -ForegroundColor Yellow'

    foreach ($entry in $script:changeLog) {
        if ($entry.Type -eq "Registry") {
            $path = $entry.Path.Replace("'", "''")
            $name = $entry.Name.Replace("'", "''")
            $old  = $entry.OldValue

            if ($null -eq $old -or $old -eq "") {
                $lines += "Remove-ItemProperty -Path '$path' -Name '$name' -ErrorAction SilentlyContinue"
            } else {
                $lines += "New-ItemProperty -Path '$path' -Name '$name' -PropertyType DWord -Value $old -Force | Out-Null"
            }
        }
    }

    $lines += 'Write-Host "Revert complete." -ForegroundColor Green'
    Set-Content -Path $revertPath -Value $lines -Encoding UTF8
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Disable Fullscreen Optimizations Globally v2" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Support this project:" -ForegroundColor Cyan
Write-Host "PayPal: https://www.paypal.com/donate/?business=UNP6WN3E95EAL&currency_code=USD" -ForegroundColor White
Write-Host "GitHub: https://github.com/anon2k24-design" -ForegroundColor White
Write-Host "Sponsor: https://github.com/sponsors/anon2k24-design" -ForegroundColor White
Write-Host ""
Write-Host "Disabling Fullscreen Optimizations (FSO) globally..." -ForegroundColor Cyan
Write-Host ""

Set-DwordSafe -Path $registryPath -Name "GameDVR_FSEBehaviorMode" -Value 2
Set-DwordSafe -Path $registryPath -Name "GameDVR_HonorUserFSEBehaviorMode" -Value 1
Set-DwordSafe -Path $registryPath -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1
Set-DwordSafe -Path $registryPath -Name "GameDVR_Enabled" -Value 0
Set-DwordSafe -Path $policyPath   -Name "AllowGameDVR" -Value 0

Write-RevertScript

Write-Host ""
Write-Host "SUCCESS! Fullscreen Optimizations / Game DVR settings updated." -ForegroundColor Green
Write-Host "Restart or sign out and sign back in for all changes to apply." -ForegroundColor Yellow
Write-Host "Log file: $logPath" -ForegroundColor White
Write-Host "Revert file: $revertPath" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"