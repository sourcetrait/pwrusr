#!/usr/bin/env pwsh
#Requires -Version 7
param(
    [Parameter(Mandatory)]
    [string] $dir,
    [string] $owner
)
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
#Set-PSDebug -Trace 1

function mk_home_dotsys {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [string] $owner
    )

    $null = New-Item -ItemType Directory -Force -Path $dir

    Set-Location -LiteralPath $dir
    $null = New-Item -ItemType Directory -Force -Path @('.config','.sys')

    Set-Location -LiteralPath (Join-Path $dir '.sys')
    $null = New-Item -ItemType Directory -Force -Path @('adhoc','cache','data','local','mnt','of','paths','secret','state','srv','sync')

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'secret')
    $null = New-Item -ItemType Directory -Force -Path @('cache','config','data','state')

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'local')
    $null = New-Item -ItemType Directory -Force -Path @('bin','doc','etc','lib','libexec','opt','src')
    
    Set-Location -LiteralPath (Join-Path $dir '.sys' 'adhoc')
    $null = New-Item -ItemType Directory -Force -Path @('bin','doc','etc','lib','libexec','opt','src')

    if ($owner) {
        Set-Location -LiteralPath $dir
        if ($IsWindows) {
            $null = icacls.exe . /setowner $owner /t /c /q
        } else {
            chmod -R go-rwx .
            chown -R $owner .
        }
    }
}

function mk_home_pwrusr {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [string] $owner
    )

    mk_home_dotsys $dir $owner


    Set-Location -LiteralPath $dir
    $null = New-Item -ItemType Directory -Force -Path @('bak','data','doc','down','mix','proj','repo','sort','tmp','tpl')
    
    Set-Location -LiteralPath (Join-Path $dir 'mix')
    $null = New-Item -ItemType Directory -Force -Path @('calc','img','mdl','snd','txt','vid','web')

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'sync')
    $null = New-Item -ItemType Directory -Force -Path @('as','at','me')

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'data')
    $null = New-Item -ItemType Directory -Force -Path 'desktop'

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'srv')
    $null = New-Item -ItemType Directory -Force -Path 'git'

    Set-Location -LiteralPath (Join-Path $dir '.sys' 'of')
    $null = New-Item -ItemType Directory -Force -Path @('cargo')

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'of' 'cargo')
    $null = New-Item -ItemType Directory -Force -Path @('bin')

    Set-Location -LiteralPath (Join-Path $dir '.config')
    $null = New-Item -ItemType Directory -Force -Path 'nushell'

    Set-Location -LiteralPath (Join-Path $dir '.config' 'nushell')
    $null = New-Item -ItemType Directory -Force -Path 'scripts'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'cache')
    $null = New-Item -ItemType Directory -Force -Path 'cargo'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'cache' 'cargo')
    $null = New-Item -ItemType Directory -Force -Path 'target'

    Set-Location -LiteralPath $dir
    $null = New-Item -ItemType Directory -Force -Path '.ssh'

    Set-Location -LiteralPath (Join-Path $dir '.ssh')
    $null = New-Item -ItemType Directory -Force -Path 'key'

    Set-Location -LiteralPath (Join-Path $dir '.ssh' 'key')
    $null = New-Item -ItemType Directory -Force -Path @('as','at','me')

    Set-Location -LiteralPath (Join-Path $dir '.ssh')
    if (-not (Test-Path -PathType Leaf -LiteralPath 'config')) {
        $null = New-Item -ItemType File -Path 'config'
    }
    if (-not (Test-Path -PathType Leaf -LiteralPath 'authorized_keys')) {
        $null = New-Item -ItemType File -Path 'authorized_keys'
    }

    if ($owner) {
        Set-Location -LiteralPath $dir
        if ($IsWindows) {
            $null = icacls.exe . /setowner $owner /t /c /q
            $null = icacls.exe (Join-Path $dir '.ssh') /inheritance:r /grant "${owner}:(OI)(CI)F" /grant 'SYSTEM:(OI)(CI)F' /q
        } else {
            chmod -R go-rwx .
            chown -R $owner .
        }
    }
}

try {
    Push-Location
    mk_home_pwrusr ([System.IO.Path]::GetFullPath($dir, (Get-Location).Path)) $owner
} finally {
    Pop-Location
}
