# Imports
Import-Module posh-git -ErrorAction SilentlyContinue

# Aliases
Remove-Item -Force Alias:where
Set-Alias which where

# Secrets
if (Test-Path "$Home\.secrets.ps1") {
    . "$Home\.secrets.ps1"
}

# Functions
function ipython {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv run --with 'ipython,pandas[plot,pyarrow]' -- ipython @args
    }
}

# Node
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --version-file-strategy=recursive --shell=powershell | Out-String | Invoke-Expression
}

# Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Out-String | Invoke-Expression
}
