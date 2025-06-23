# install-module posh-git -scope currentuser
Import-Module posh-git -ErrorAction SilentlyContinue

if (Test-Path "$Home\.secrets.ps1") {
    . "$Home\.secrets.ps1"
}

$Env:ASTRO_TELEMETRY_DISABLED = '1'
$Env:NEXT_TELEMETRY_DISABLED = '1'

$Env:NPM_CONFIG_AUDIT = 'false'
$Env:NPM_CONFIG_FUND = 'false'
$ENV:NPM_CONFIG_UPDATE_NOTIFIER = 'false'

# Aliases
# - view one: `get-item alias:<name>`
# - view all: `get-childitem alias:`

Remove-Item -Force Alias:gu -ErrorAction SilentlyContinue
Set-Alias touch New-Item
Set-Alias lns New-SymbolicLink
Set-Alias rmf Remove-ItemForce
Set-Alias scl Format-ScoopList
Set-Alias wgl Format-WingetList
Set-Alias gu Undo-GitCommit
Set-Alias g git.exe
Set-Alias b bat.exe
Set-Alias c Clear-Host
Set-Alias l Get-ChildItem

# Functions
# - view one: `get-content function:<name>`
# - view all: `get-childitem function:`

# Get the path of an executable
function Which {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Name
    )
    $cmd = Get-Command -CommandType Application -Name $Name -ErrorAction SilentlyContinue @args
    if ($cmd) {
        $cmd | Select-Object -First 1 -ExpandProperty Source
    }
}

# Run jupyter console in an isolated virtual environment
function IPython {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv run --with 'ipython,pandas[plot,pyarrow]' -- ipython @args
    }
}

# Create a soft link (requires admin shell)
function New-SymbolicLink {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Source,
        [Parameter(Mandatory = $true)]
        [String]$Destination
    )
    $src = Get-Item -LiteralPath $Source -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Target $src.FullName -Path $Destination @args
}

# Take ownership and give yourself full permission using DOS (requires admin shell)
function Set-Ownership {
    param (
        [Parameter(Mandatory = $true)]
        [String[]]$Path
    )
    foreach ($p in $Path) {
        $p = (Resolve-Path $p).Path
        $u = "$Env:UserDomain\$Env:UserName"
        takeown /R /F $p /D Y
        icacls $p /grant "${u}:(F)" /T
    }
}

# Remove files and folders using DOS
function Remove-ItemForce {
    param (
        [Parameter(Mandatory = $true)]
        [String[]]$Path
    )
    foreach ($p in $Path) {
        # Skip if path does not exist
        $item = Get-Item -LiteralPath $p -ErrorAction SilentlyContinue
        if (-not $item) {
            continue
        }

        # Use absolute path for command prompt
        $fullPath = $item.FullName
        if ($item.PSIsContainer) {
            cmd /c rd /s /q "$fullPath"
        } else {
            cmd /c del /f /q "$fullPath"
        }
    }
}

# Undo the last commit but leave files staged
function Undo-GitCommit {
    git reset --soft HEAD~1 @args
}

# Filter out write-host from scoop list
function Format-ScoopList {
    scoop list @args 6>$null
}

# Filter out system apps from winget list
function Format-WingetList {
    # install-module microsoft.winget.client
    Get-WinGetPackage @args
    | Where-Object { $_.Id -notmatch 'ARP|MSIX|Microsoft\.(UI|VCLibs|VCRedist)' }
}

# Node
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --version-file-strategy=recursive --shell=powershell
    | Out-String
    | Invoke-Expression
}

# Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell
    | Out-String
    | Invoke-Expression
}
