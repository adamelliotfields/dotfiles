# Apt

## Check what is running

```sh
ps -ef | rg 'apt|dpkg|unattended'
systemctl status --no-pager unattended-upgrades.service apt-daily.service apt-daily-upgrade.service
systemctl list-timers --all | rg 'apt-daily|apt-daily-upgrade'
```

## Disable unattended upgrades

Edit `/etc/apt/apt.conf.d/20auto-upgrades`:

```conf
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
```

On Ubuntu, this is enough to stop automatic `apt-get update` and unattended installs when there are no other `APT::Periodic::*` settings.

If you want to make that explicit, add `/etc/apt/apt.conf.d/99disable-periodic`:

```conf
APT::Periodic::Enable "0";
```

## Disable systemd timers too

If you also want systemd to stop invoking the APT wrapper script:

```sh
sudo systemctl stop apt-daily.service apt-daily-upgrade.service unattended-upgrades.service
sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer unattended-upgrades.service
```

## Remove the package

```sh
sudo apt remove unattended-upgrades
```

## Verify

```sh
systemctl is-enabled apt-daily.timer apt-daily-upgrade.timer unattended-upgrades.service
apt-config dump | rg 'APT::Periodic::(Enable|Update-Package-Lists|Unattended-Upgrade)'
```
