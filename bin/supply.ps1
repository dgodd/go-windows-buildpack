[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)] [string]$BuildDir,
[Parameter(Mandatory=$True,Position=2)] [string]$CacheDir,
[Parameter(Mandatory=$True,Position=3)] [string]$DepsDir,
[Parameter(Mandatory=$True,Position=4)] [string]$DepsIdx
)

$ErrorActionPreference = "Stop"

$Version = (Get-Content "$PSScriptRoot/../VERSION" -Raw).Replace("`n","").Replace("`r","")
Write-Output "-----> Go Buildpack (version $Version)"
# Write-Output "       BuildDir: $BuildDir"
# Write-Output "       CacheDir: $CacheDir"
# Write-Output "       DepsDir: $DepsDir"
# Write-Output "       DepsIdx: $DepsIdx"
# Write-Output ""


Write-Output "-----> Download go"
$ProgressPreference = 'SilentlyContinue'
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/go/go1.11.4.windows-amd64.zip', "$DepsDir/$DepsIdx/go.zip")
$ExpectedSHA = 'eeb20e21702f2b9469d9381df5de85e2f731b64a1f54effe196d0f7d0227fe14'
$ActualSHA = (Get-FileHash "$DepsDir/$DepsIdx/go.zip" -Algorithm SHA256).Hash
If ($ExpectedSHA -ne $ActualSHA) {
    Write-Output "go.zip checksum did not match. expected '$ExpectedSHA', found '$ActualSHA'" 
    Exit 1
}

Write-Output "-----> Extract go"
Expand-Archive -Path "$DepsDir/$DepsIdx/go.zip" -DestinationPath "$DepsDir/$DepsIdx" -Force
Move-Item -Path "$DepsDir/$DepsIdx/go/*" -Destination "$DepsDir/$DepsIdx"
Remove-Item -Path "$DepsDir/$DepsIdx/go"
