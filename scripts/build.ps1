$ErrorActionPreference = "Stop"

$Version = (Get-Content "$PSScriptRoot/../VERSION" -Raw).Replace("`n","").Replace("`r","")

cd "$PSScriptRoot/.."
Compress-Archive -LiteralPath bin, VERSION -CompressionLevel Optimal -DestinationPath "$PSScriptRoot/../go_buildpack-windows2016-v$Version.zip" -Force

