$ErrorActionPreference = "Stop"

$Version = (Get-Content "$PSScriptRoot/../VERSION" -Raw).Replace("`n","").Replace("`r","")

cd "$PSScriptRoot/.."
$env:GOOS = "windows"
go build -o bin/supply.exe ./supply/
go build -o bin/finalize.exe ./finalize/
Compress-Archive -LiteralPath bin, manifest.yml, VERSION -CompressionLevel Optimal -DestinationPath "$PSScriptRoot/../go_buildpack-windows2016-v$Version.zip" -Force

