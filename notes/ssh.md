# SSH

## Generate a key

```sh
# create ~/.ssh if needed
mkdir -p ~/.ssh

# RSA 4096-bit key pair with comment
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "$USER@$(hostname)"
```

## Set permissions

```sh
# directory: rwx
chmod 700 ~/.ssh

# files: rw
chmod 600 ~/.ssh/*
```

## Client settings

Put this in `~/.ssh/config`:

```
Host *
  HashKnownHosts no

Host your-server
  User your-user
  HostName your-server-ip-or-dns
  IdentityFile ~/.ssh/id_rsa
```

## Server settings

Edit `/etc/ssh/sshd_config` with:

```
AddressFamily inet
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
KbdInteractiveAuthentication no
UsePAM yes
PrintLastLog no
```

Then reload SSH:

```sh
sudo systemctl reload ssh
```

And add your public key to `~/.ssh/authorized_keys`:

```sh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Windows

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

> NB: Firewall cmdlets require an Administrator shell.

```pwsh
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
