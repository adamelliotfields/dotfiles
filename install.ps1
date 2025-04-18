# Ensure profile directory exists
New-Item -Force -ItemType directory (Split-Path $Profile)

# Symlink profile
New-Item -Force -ItemType SymbolicLink -Target "$PSScriptRoot/windows/profile.ps1" -Path $Profile
