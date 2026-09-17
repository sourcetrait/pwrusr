#!/usr/bin/env pwsh
#Requires -Version 7
param(
    [Parameter(Mandatory)]
    [System.IO.Path] $dir,
    [Parameter(Optional)]
    [string] $owner
)
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function mk_sysusr {
    param(
        [Parameter(Mandatory)]
        [System.IO.Path] $dir,
        [Parameter(Optional)]
        [string] $owner
    )

    New-Item -ItemType Directory -Force -Path $dir

    Set-Location -LiteralPath $dir
    New-Item -ItemType Directory -Force -Path @('.config','bak','data','doc','down','mix','proj','repo','sort','sys','tmp','tpl')

    Set-Location -LiteralPath (JoinPath $dir '.config')
    New-Item -ItemType Directory -Force -Path 'secret'

    Set-Location -LiteralPath (JoinPath $dir 'mix')
    New-Item -ItemType Directory -Force -Path @('calc','img','mdl','snd','txt','vid','web')

    Set-Location -LiteralPath (JoinPath $dir 'sys')
    New-Item -ItemType Directory -Force -Path @('cache','data','local','mnt','of','secret','state','srv','sync','use')

    Set-Location -LiteralPath (JoinPath $dir 'sys' 'secret')
    New-Item -ItemType Directory -Force -Path @('cache','data','state')

    Set-Location -LiteralPath (JoinPath $dir 'sys' 'local')
    New-Item -ItemType Directory -Force -Path @('bin','doc','etc','lib','opt','share','src','var')

    Set-Location -LiteralPath (JoinPath $dir 'sys' 'sync')
    New-Item -ItemType Directory -Force -Path @('as','at','me')

    Set-Location -LiteralPath (JoinPath $dir 'sys' 'use')
    New-Item -ItemType Directory -Force -Path @('asset','cfg','data','doc','exe','lib','pkg','src')
    
    if ($owner -ne $null) {
        Set-Location -LiteralPath $dir
        if ($IsWindows) {
            icacls.exe . /setowner $owner /t /c
        } else {
            chmod -R go-rwx .
            chown -R $owner .
        }
    }
}

function mk_pwrusr {
    param(
        [Parameter(Mandatory)]
        [System.IO.Path] $dir,
        [Parameter(Optional)]
        [string] $owner
    )

    mk_sysusr $dir $owner

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'data')
    New-Item -ItemType Directory -Force -Path 'desktop'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'srv')
    New-Item -ItemType Directory -Force -Path 'git'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'of')
    New-Item -ItemType Directory -Force -Path 'nu'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'of' 'nu')
    New-Item -ItemType Directory -Force -Path @('exe','mod')

    Set-Location -LiteralPath (Join-Path $dir '.config')
    New-Item -ItemType Directory -Force -Path 'nushell'

    Set-Location -LiteralPath (Join-Path $dir '.config' 'nushell')
    if (Test-Path -LiteralPath 'scripts') {
        $retire_dir = mkdtemp (Join-Path $dir 'tmp' 'retire') 'mkpwrhome.'
        $retire_to = Join-Path $retire_dir '.config' 'nushell'
        New-Item -ItemType Directory -Force -Path $retire_to
        Move-Item -LiteralPath 'scripts' -Destination $retire_to
    }
    New-Item -ItemType SymbolicLink -Path (Join-Path '..' '..' 'sys' 'of' 'nu') -Target 'scripts'

    Set-Location -LiteralPath (Join-Path $dir 'sys' 'cache')
    New-Item -ItemType Directory -Force -Path 'cargo'
    
    Set-Location -LiteralPath (Join-Path $dir 'sys' 'cache' 'cargo')
    New-Item -ItemType Directory -Force -Path 'target'

    Set-Location -LiteralPath (Join-Path $dir)
    New-Item -ItemType Directory -Force -Path '.ssh'

    Set-Location -LiteralPath (Join-Path $dir '.ssh')
    New-Item -ItemType Directory -Force -Path 'key'

    Set-Location -LiteralPath (Join-Path $dir '.ssh' 'key')
    New-Item -ItemType Directory -Force -Path @('as','at','me')

    Set-Location -LiteralPath (Join-Path $dir '.ssh')
    if (-not (Test-Path -LiteralPath 'config' -Path Leaf)) {
        New-Item -ItemType File -Path 'config'
    }
    if (-not (Test-Path -LiteralPath 'authorized_keys')) {
        New-Item -ItemType File -Path 'authorized_keys'
    }

    if ($owner -ne $null) {
        Set-Location -LiteralPath $dir
        if ($IsWindows) {
            icacls.exe . /setowner $owner /t /c
            icacls.exe (Join-Path $dir '.ssh') /inheritance:r /grant "${owner}:(OI)(CI)F" /grant 'SYSTEM:(OI)(CI)F'
        } else {
            chmod -R go-rwx .
            chown -R $owner .
        }
    }
}

function mkdtemp {
    param(
        [Parameter(Mandatory)]
        [System.IO.Path] $dir,
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

mk_pwrusr $dir $owner
