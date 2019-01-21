@ECHO OFF
SET ScriptDir=%~dp0
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%ScriptDir%finalize.ps1' %1 %2 %3 %4";
