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

## Copy files with scp

Copy a file from the local machine to a remote machine:

```sh
scp <local-file> your-server:<remote-path>
```

Copy a file from the remote machine to the local machine:

```sh
scp your-server:<remote-file> <local-path>
```

Use `-r` to copy a directory in either direction:

```sh
scp -r <local-directory> your-server:<remote-path>
scp -r your-server:<remote-directory> <local-path>
```

## Sync files with rsync

Sync a local directory to a remote machine:

```sh
rsync -avz <local-directory>/ your-server:<remote-path>/
```

Sync a remote directory to the local machine:

```sh
rsync -avz your-server:<remote-directory>/ <local-path>/
```

A trailing slash on the *source* controls whether `rsync` copies the directory itself or only its contents. For example:

```sh
# Copy foo inside dir
rsync -avz /path/to/foo your-server:/path/to/dir/

# Copy the contents of foo inside dir
rsync -avz /path/to/foo/ your-server:/path/to/dir/
```

Use the first form when the destination should contain a new `foo` directory, such as copying a project into a backups directory.

Use the second form when the source and destination are equivalent directories, such as updating the contents of an existing project. The same rule applies when syncing from remote to local.

When the destination directory already exists, `/path/to/dir`, `/path/to/dir/`, and `/path/to/dir/.` all target that directory.

The options preserve file metadata (`-a`), show transferred files (`-v`), and compress data in transit (`-z`).
