@echo off
go build -ldflags="-s -w" -o .\bin\supply.exe .\supply
go build -ldflags="-s -w" -o .\bin\finalize.exe .\finalize
del .\bin\supply .\bin\finalize
