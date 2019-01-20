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
