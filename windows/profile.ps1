# Imports
Import-Module posh-git -ErrorAction SilentlyContinue

# Secrets
if (Test-Path "$Home\.secrets.ps1") {
    . "$Home\.secrets.ps1"
}

# Exports
$Env:ASTRO_TELEMETRY_DISABLED = '1'
$Env:NEXT_TELEMETRY_DISABLED = '1'

# Aliases
# - view one: `get-item alias:<name>`
# - view all: `get-childitem alias:`
Set-Alias which where.exe
Set-Alias touch New-Item
Set-Alias lns New-SymLink
Set-Alias rmf Remove-ItemForce
Set-Alias gus Undo-GitCommitStaged
Set-Alias gu Undo-GitCommit
Set-Alias g git.exe
Set-Alias b bat.exe
Set-Alias c Clear-Host
Set-Alias l Get-ChildItem

# Functions
# - view one: `get-content function:<name>`
# - view all: `get-childitem function:`
function IPython {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv run --with 'ipython,pandas[plot,pyarrow]' -- ipython @Args
    }
}

# Undoes the last commit and leaves files staged
function Undo-GitCommit {
    git reset --soft HEAD~1 @Args
}

# Undoes the last commit and unstages all files
function Undo-GitCommitStaged {
    git reset --soft HEAD~1 @Args
    git reset
}

function New-SymLink {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Source,
        [Parameter(Mandatory = $true)]
        [String]$Destination
    )
    New-Item -ItemType SymbolicLink -Target $Source -Path $Destination
}

function Remove-ItemForce {
    param (
        [Alias("FullName", "PSPath")]
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]$Path
    )
    foreach ($p in $Path) {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Path $p
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
