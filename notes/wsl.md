# WSL

## Networking

Enable mirrored networking in `~/.wslconfig` on Windows:

```ini
[wsl2]
networkingMode=Mirrored
```

## systemd

Enable systemd in `/etc/wsl.conf` on Linux:

```ini
[boot]
systemd=true
```

## SSH

Check if the server is running:

```pwsh
Get-Service -name sshd
```

Stop the server and disable the service:

```pwsh
Stop-Service -name sshd
Set-Service -name sshd -StartupType Disabled
```

Disable the existing Defender firewall rule:

```pwsh
# Firewall cmdlets require an administrator shell
Disable-NetFirewallRule -Name "OpenSSH-Server-In-TCP"
```

Install SSH server in WSL:

```sh
sudo apt install ssh
sudo systemctl enable --now ssh
```

Add new Defender and Hyper-V firewall rules:

```pwsh
New-NetFirewallRule -DisplayName "OpenSSH SSH Server (wsl)" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
New-NetFirewallHyperVRule -DisplayName "WSL Inbound IPv4 SSH Allow" -Direction Inbound -Protocol ICMPv4 -LocalPorts 22 -Action Allow
```

## GPG

The steps are similar to Linux, but you need to install GnuPG with WinGet:

```pwsh
winget install -s winget --id gnupg.gnupg
```

And get the key ID with PowerShell:

```pwsh
$yourKey = gpg --list-keys --with-colons $yourEmail |
Where-Object { $_.StartsWith('pub:') } |
ForEach-Object { ($_ -split ':')[4] }
```

Then add a Task Scheduler program that runs at login to start the GPG agent:

```pwsh
powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$ErrorActionPreference='SilentlyContinue'; $env:Path=(Join-Path $env:ProgramFiles 'GnuPG\bin') + ';' + $env:Path; gpgconf --launch keyboxd; gpg-connect-agent /bye;"
```

## Keeping WSL Awake

Windows will immediately suspend WSL when there are no active sessions. To work around this, run a VBScript at login which keeps WSL awake without launching a terminal.

Create `~/wsl.vbs` with:

```vbs
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "wsl.exe --exec sleep infinity", 0
Set WshShell = Nothing
```

Then create a scheduled task to run the script.

> [!NOTE]
> Scheduling tasks requires an administrator shell.

```pwsh
$taskName = "WSL"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $(whoami)
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "$env:USERPROFILE\wsl.vbs"
$settings = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Compatibility Win8 -ExecutionTimeLimit 0
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Settings $settings
```
