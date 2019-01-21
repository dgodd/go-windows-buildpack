[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)] [string]$BuildDir,
[Parameter(Mandatory=$True,Position=2)] [string]$CacheDir,
[Parameter(Mandatory=$True,Position=3)] [string]$DepsDir,
[Parameter(Mandatory=$True,Position=4)] [string]$DepsIdx
)

$ErrorActionPreference = "Stop"
$env:PATH += ";$DepsDir/$DepsIdx/bin"

Write-Output "-----> Build app"
Set-Location $BuildDir
go build -o myapp.exe .
if ($lastexitcode -ne 0) {
    Write-Output "ERROR building app with go"
    Write-Output "EXITCODE: $lastexitcode"
    Exit 1
}

Write-Output "-----> Configure runtime path and env vars"
$dirs = Get-Childitem -Path $DepsDir | where{ Join-Path $_.FullName "bin" | Test-Path } | %{ '%DEPS_DIR%\' + $_.Name + '\bin' } | &{$ofs=';';"$input"}
Set-Content -Path "$DepsDir/../profile.d/000_multi-supply.bat" -Value "set PATH=$dirs;%PATH%"
Foreach ($d in (Get-Childitem -Path $DepsDir | where{ Join-Path $_.FullName "profile.d" | Test-Path })) {
    Foreach ($f in (Get-Childitem -Path "$DepsDir/$d/profile.d")) {
        Copy-Item $f.FullName -Destination "$DepsDir/../profile.d/${d}_${f}"
    }
}
