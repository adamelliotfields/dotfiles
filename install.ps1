# Ensure PowerShell profile directory exists
New-Item -Force -ItemType directory (Split-Path $PROFILE)

# Symlink profile and config
New-Item -Force -ItemType SymbolicLink -Target "$PSScriptRoot\windows\profile.ps1" -Path $PROFILE
New-Item -Force -ItemType SymbolicLink -Target "$PSScriptRoot\windows\config.json" -Path "$HOME\Documents\PowerShell\powershell.config.json"
