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

function mk_sysusr {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [string] $owner
    )

    $null = New-Item -ItemType Directory -Force -Path $dir

    Set-Location -LiteralPath $dir
    $null = New-Item -ItemType Directory -Force -Path @('.config','bak','data','doc','down','mix','proj','repo','sort','sys','tmp','tpl')

    Set-Location -LiteralPath (Join-Path $dir '.config')
    $null = New-Item -ItemType Directory -Force -Path 'secret'

    Set-Location -LiteralPath (Join-Path $dir 'mix')
    $null = New-Item -ItemType Directory -Force -Path @('calc','img','mdl','snd','txt','vid','web')

    Set-Location -LiteralPath (Join-Path $dir 'sys')
    $null = New-Item -ItemType Directory -Force -Path @('cache','data','local','mnt','of','secret','state','srv','sync','use')

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'secret')
    $null = New-Item -ItemType Directory -Force -Path @('cache','data','state')

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'local')
    $null = New-Item -ItemType Directory -Force -Path @('bin','doc','etc','lib','opt','share','src','var')

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'sync')
    $null = New-Item -ItemType Directory -Force -Path @('as','at','me')

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'use')
    $null = New-Item -ItemType Directory -Force -Path @('asset','cfg','data','doc','exe','lib','pkg','src')
    
    if ($owner -ne $null) {
        Set-Location -LiteralPath $dir
        if ($IsWindows) {
            $null = icacls.exe . /setowner $owner /t /c /q
        } else {
            chmod -R go-rwx .
            chown -R $owner .
        }
    }
}

function mk_pwrusr {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [string] $owner
    )

    mk_sysusr $dir $owner

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'data')
    $null = New-Item -ItemType Directory -Force -Path 'desktop'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'srv')
    $null = New-Item -ItemType Directory -Force -Path 'git'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'of')
    $null = New-Item -ItemType Directory -Force -Path 'nu'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'of' 'nu')
    $null = New-Item -ItemType Directory -Force -Path @('mod','plugins')

    Set-Location -LiteralPath (Join-Path $dir '.config')
    $null = New-Item -ItemType Directory -Force -Path 'nushell'

    Set-Location -LiteralPath (Join-Path $dir '.config' 'nushell')
    if (Test-Path -LiteralPath 'scripts') {
        $retire_dir = mkdtemp (Join-Path $dir 'tmp' 'retire') 'mkpwrhome.'
        $retire_to = Join-Path $retire_dir '.config' 'nushell'
        $null = New-Item -ItemType Directory -Force -Path $retire_to
        Move-Item -LiteralPath 'scripts' -Destination $retire_to
    }
    $null = New-Item -ItemType SymbolicLink -Path 'scripts' -Target (Join-Path '..' '..' 'sys' 'of' 'nu' 'mod')

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

    if ($owner -ne $null) {
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

function mkdtemp {
    param(
        [Parameter(Mandatory)]
        [string] $dir,
        [string] $prefix = 'tmp-'
    )

    $dir = Get-Item -LiteralPath $dir -ErrorAction Stop
    if (-not $dir.PSIsContainer) {
        throw "not a directory: $dir"
    }

    for ($i = 0; $i -lt 100; $i++) {
        $dirname = $prefix + [System.IO.Path]::GetRandomFileName()
        $tempdir = Join-Path $dir.FullName $dirname

        try {
            return New-Item -ItemType Directory -Path $tempdir -ErrorAction Stop
        }
        catch {
            if (Test-Path -LiteralPath $tempdir) { continue }
            throw
        }
    }

    throw "mkdtmp failed for: $dir"
}

try {
    Push-Location
    mk_pwrusr ([System.IO.Path]::GetFullPath($dir, (Get-Location).Path)) $owner
} finally {
    Pop-Location
}
