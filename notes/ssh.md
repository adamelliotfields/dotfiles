# SSH

## Generate a key

```sh
# create ~/.ssh if needed
mkdir -p ~/.ssh

# RSA 4096-bit key pair with comment
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "$USER@$(hostname)"
```

## Set permissions

> [!NOTE]
> Known hosts and public keys can be `644`.

```sh
# directory: rwx
chmod 700 ~/.ssh

# files: rw
chmod 600 ~/.ssh/*
```

## Client settings

> [!NOTE]
> The config is read top-to-bottom. Put the wildcard host last if you want specific hosts to override individual settings.

Put this in `~/.ssh/config`:

```
Host *
  HashKnownHosts no
  UpdateHostKeys no
  IdentitiesOnly yes

Host your-server
  HostName <server>
  IdentityFile ~/.ssh/id_rsa
  User <user>
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
