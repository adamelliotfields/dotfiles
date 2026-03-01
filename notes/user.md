# User

How to create users and groups in Ubuntu.

## Groups

Use `groupadd` to create a new group:
```sh
sudo groupadd --gid 1000 adam
```

## Users

Use `useradd` to create a new user and add it to a group:
```sh
sudo useradd --uid 1000 --gid 1000 --gecos "" adam
```

That will prompt for a password. Pass `--disabled-password` to skip.

## Sudo

Add a user to the `sudo` group and enable passwordless sudo:
```sh
usermod -aG sudo adam
echo "adam ALL=(ALL:ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/adam >/dev/null
```

## Lingering

When you create `systemd` user services, they don't start at boot by default. Use `loginctl` to enable lingering for a user:
```sh
loginctl enable-linger adam  # creates /var/lib/systemd/linger/adam
```

When you need to run `systemctl --user` commands for that user, use `machinectl` to create a new session:
```sh
apt install -y systemd-container  # for machinectl
machinectl shell adam@  # defaults to .host
```
