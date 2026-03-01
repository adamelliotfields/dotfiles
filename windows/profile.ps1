# install-module posh-git -scope currentuser
Import-Module posh-git -ErrorAction SilentlyContinue

if (Test-Path "$Home\.secrets.ps1") {
    . "$Home\.secrets.ps1"
}

$Env:VISUAL = 'code -w'
$Env:EDITOR = 'edit'
$Env:GIT_EDITOR = $Env:EDITOR

$Env:PAGER = 'less -FRSX --tabs=2' # scoop install less
$Env:LESSHISTSIZE = 0

# llama.cpp
$Env:LLAMA_ARG_FIT = 0
$ENv:LLAMA_ARG_DIO = 1
$Env:LLAMA_ARG_MMAP = 0
$Env:LLAMA_ARG_BATCH = 4096
$Env:LLAMA_ARG_UBATCH = 2048
$Env:LLAMA_ARG_MODELS_MAX = 1
$Env:LLAMA_ARG_N_GPU_LAYERS = 'all'
$Env:LLAMA_HOME = "$HOME\.llama.cpp"  # clone llama.cpp here
$Env:LLAMA_ARG_MODELS_DIR = "$HOME\.cache\llama.cpp"  # download gguf here
$Env:LLAMA_ARG_MODELS_PRESET = "$Env:LLAMA_ARG_MODELS_DIR\models.ini"

# node
$Env:NODE_NO_WARNINGS = '1'
$Env:NODE_OPTIONS='--no-deprecation'

# npm
$Env:NPM_CONFIG_FUND = 'false'
$Env:NPM_CONFIG_AUDIT = 'false'
$Env:NPM_CONFIG_LOGLEVEL = 'error'
$Env:NPM_CONFIG_PROGRESS = 'false'
$Env:NPM_CONFIG_UPDATE_NOTIFIER = 'false'

# telemetry
$Env:DISABLE_TELEMETRY = '1' # statsig
$Env:DISABLE_ERROR_REPORTING = '1' # sentry
$Env:ASTRO_TELEMETRY_DISABLED = '1' # astro
$Env:HF_HUB_DISABLE_TELEMETRY = '1' # huggingface
$Env:WRANGLER_SEND_METRICS = 'false' # cloudflare
$Env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = '1' # claude

# Aliases
# - view one: `get-item alias:<name>`
# - view all: `get-childitem alias:`

# https://github.com/ScoopInstaller/Main/blob/master/bucket/uutils-coreutils.json
Remove-Item -Force Function:mkdir -ErrorAction SilentlyContinue
Remove-Item -Force Alias:rmdir -ErrorAction SilentlyContinue
Remove-Item -Force Alias:sleep -ErrorAction SilentlyContinue
Remove-Item -Force Alias:echo -ErrorAction SilentlyContinue
Remove-Item -Force Alias:sort -ErrorAction SilentlyContinue
Remove-Item -Force Alias:cat -ErrorAction SilentlyContinue
Remove-Item -Force Alias:dir -ErrorAction SilentlyContinue
Remove-Item -Force Alias:pwd -ErrorAction SilentlyContinue
Remove-Item -Force Alias:tee -ErrorAction SilentlyContinue
Remove-Item -Force Alias:cp -ErrorAction SilentlyContinue
Remove-Item -Force Alias:ls -ErrorAction SilentlyContinue
Remove-Item -Force Alias:mv -ErrorAction SilentlyContinue
Remove-Item -Force Alias:rm -ErrorAction SilentlyContinue

Remove-Item -Force Alias:gu -ErrorAction SilentlyContinue
Remove-Item -Force Alias:sl -ErrorAction SilentlyContinue

Set-Alias lns New-SymbolicLink
Set-Alias rmf Remove-ItemForce
Set-Alias dl Download
Set-Alias gu Undo-GitCommit
Set-Alias sl ScoopList
Set-Alias wl WingetList
Set-Alias c Clear-Host
Set-Alias g git.exe
Set-Alias l LSDeluxe
Set-Alias m micro.exe

# Functions
# - view one: `get-content function:<name>`
# - view all: `get-childitem function:`

# Create a soft link (requires admin shell)
function New-SymbolicLink {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Source,
        [Parameter(Mandatory = $true)]
        [String]$Destination
    )
    $src = Get-Item -LiteralPath $Source -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Target $src.FullName -Path $Destination @Args
}

# Take ownership and give yourself full permission using DOS (could require admin shell)
function Take {
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
        [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
        [String[]]$Path
    )
    foreach ($p in $Path) {
        $item = Get-Item -Force -LiteralPath $p -ErrorAction SilentlyContinue
        $fullPath = $item.FullName

        # Skip if path does not exist
        if (-not $item) {
            continue
        }

        # Don't use cmd if hidden
        if ($item.Attributes.ToString() -match 'Hidden') {
            Remove-Item -Recurse -Force -Path $fullPath
        }

        # Use absolute path for cmd
        if ($item.PSIsContainer) {
            cmd /c rd /s /q "$fullPath"
        } else {
            cmd /c del /f /q "$fullPath"
        }
    }
}

# Undo the last commit but leave files staged
function Undo-GitCommit {
    git reset --soft HEAD~1 @Args
}

# Download a file fast
function Download {
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
        [String[]]$Urls,
        [Parameter()]
        [Alias('o')]
        [String]$OutFile
    )

    $options = @(
        '--disable-ipv6'
        '--console-log-level=warn'
        '--file-allocation=none'
        '--summary-interval=0'
        '--max-connection-per-server=4'
        '--min-split-size=1M'
    )

    # If any URL is Hugging Face, add authorization header
    foreach ($u in $Urls) {
        $uri = [System.Uri]::new($u)
        if ($uri.Host -match '(^|\.)hf\.co$' -or $uri.Host -match '(^|\.)huggingface\.co$') {
            if ($env:HF_TOKEN) {
                $options += "--header=Authorization: Bearer ${env:HF_TOKEN}"
            }
            break
        }
    }

    if ($Urls.Length -gt 1) {
        aria2c @options -Z @Urls
    } else {
        $url = $Urls[0]
        if (-not $OutFile) {
            $uri = [System.Uri]::new($url)
            $OutFile = [System.Uri]::UnescapeDataString($uri.Segments[-1])
        }
        if (Test-Path "$OutFile.aria2") {
            $options += '--continue'
        }
        aria2c @options -o $OutFile $url
    }
}

# Get the path of an executable
function Which {
    param (
        [Parameter(Mandatory = $true)]
        [String]$Name
    )

    $cmd = Get-Command -CommandType Application -Name $Name -ErrorAction SilentlyContinue @Args
    if ($cmd) {
        $cmd | Select-Object -First 1 -ExpandProperty Source
    }
}

# List directory items with icons
function LSDeluxe {
    lsd -lA --date=relative --group-dirs=first --permission=octal --size=short @Args
}

# Filter out write-host from scoop list
function ScoopList {
    scoop list @Args 6>$null
}

# Filter out system apps from winget list
function WingetList {
    # install-module microsoft.winget.client
    Get-WinGetPackage @Args
    | Where-Object { $_.Id -notmatch 'ARP|MSIX|Microsoft\.(UI|VCLibs|VCRedist)' }
}

# Enter Visual Studio developer shell
function Enter-DevShell {
    Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstallPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" -DevCmdArguments "-arch=x64 -host_arch=x64"
}

# Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell
    | Out-String
    | Invoke-Expression
}
