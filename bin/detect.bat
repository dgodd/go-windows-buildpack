@echo off
if EXIST %1\go.mod (
  echo go
  exit 0
) else (
  exit 1
)

