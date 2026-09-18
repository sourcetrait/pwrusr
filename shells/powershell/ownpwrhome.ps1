#!/usr/bin/env pwsh
#Requires -Version 7
param(
    [Parameter(Mandatory)]
    [string] $dir,
    [Parameter(Mandatory)]
    [string] $owner
)
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
#Set-PSDebug -Trace 1

function own_pwrusr_home {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [Parameter(Mandatory)]
        [string] $owner
    )

    Set-Location -LiteralPath $dir
    if ($IsWindows) {
        $null = icacls.exe . /setowner $owner /t /c /q
        $null = icacls.exe (Join-Path $dir '.ssh') /inheritance:r /grant "${owner}:(OI)(CI)F" /grant 'SYSTEM:(OI)(CI)F' /q
    } else {
        chmod -R go-rwx .
        chown -R $owner .
    }
}

try {
    Push-Location
    own_pwrusr_home ([System.IO.Path]::GetFullPath($dir, (Get-Location).Path)) $owner
} finally {
    Pop-Location
}
