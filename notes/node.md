# Node.js

Install Node.js (and `npm`/`npx`) from the [NodeSource PPA](https://github.com/nodesource/distributions). Replace `<major>` with the release line you want:

```sh
curl -fsSL https://deb.nodesource.com/setup_<major>.x | sudo -E bash -
sudo apt install -y nodejs
```

The setup script adds the repository, imports the GPG key, and runs `apt-get update`. The `-E` flag preserves your environment variables when running as root (`sudo` resets them by default).

## Global packages

> [!NOTE]
> `NPM_CONFIG_*` environment variables override `~/.npmrc` if both are set.

Set a `prefix` so global installs don't require `sudo` and binaries land in `~/.local/bin`. Either create `~/.npmrc` with:

```ini
prefix=/home/<user>/.local
```

Or export it in [`~/.exports`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.exports):

```sh
export NPM_CONFIG_PREFIX="${HOME}/.local"
```

## Minimum release age

> [!NOTE]
> Added in [`11.10.0`](https://docs.npmjs.com/cli/v11/using-npm/changelog#11100-2026-02-11).

For supply-chain safety, set `min-release-age` so npm only installs versions published more than a day ago:

```sh
export NPM_CONFIG_MIN_RELEASE_AGE=1
```

In GitHub Actions, set it at the workflow level so it applies to every job:

```yaml
env:
  NPM_CONFIG_MIN_RELEASE_AGE: '1'
```
