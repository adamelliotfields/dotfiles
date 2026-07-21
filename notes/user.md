# User

How to create users and groups in Ubuntu.

## Groups

Use `groupadd` to create a new group:
```sh
sudo groupadd --gid 1000 adam
```

To list groups:
```sh
getent group
```

To delete:
```sh
sudo groupdel adam
```

## Users

Use `useradd` to create a new user and add it to a group:
```sh
sudo useradd --disabled-password --uid 1000 --gid 1000 --gecos "" adam
```

To create the home folder manually:
```sh
sudo mkhomedir_helper adam
```

To list users:
```sh
getent passwd
```

To delete:
```sh
sudo userdel -r adam
```

## Sudo

Add a user to the `sudo` group and enable passwordless sudo:
```sh
sudo usermod -aG sudo adam
echo "adam ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/adam >/dev/null
```

## Lingering

When you create `systemd` user services, they don't start at boot by default. Use `loginctl` to enable lingering for a user:
```sh
sudo loginctl enable-linger adam  # creates /var/lib/systemd/linger/adam
```

When you need to run `systemctl --user` commands for that user, use `machinectl` to create a new session:
```sh
sudo apt install -y systemd-container  # for machinectl
sudo machinectl shell adam@  # defaults to .host
systemctl --user {enable,start,status} <service>
```
