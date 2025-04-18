<div align="center">
  <img src="./dotfiles.jpg" width="360" height="270" alt="A digital world with a shell and fish" />
  <h1><code>dotfiles</code></h1>
</div>

See [GitHub does dotfiles](https://dotfiles.github.io).

## Features

  * [`apt.sh`](./lib/apt.sh): Updates and installs Apt packages.
  * [`btop.sh`](./lib/btop.sh): Installs btop from source for GPU monitoring.
  * [`bun.sh`](./lib/bun.sh): Installs Bun for your OS and arch.
  * [`chsh.sh`](./lib/chsh.sh): Sets the default shell for the current user.
  * [`clone.sh`](./lib/clone.sh): Clones GitHub repos to `$HOME`.
  * [`deb.sh`](./lib/deb.sh): Installs Deb packages from GitHub.
  * [`deno.sh`](./lib/deno.sh): Installs Deno for your OS and arch.
  * [`fish.sh`](./lib/fish.sh): Installs Fish from the fish-shell PPA.
  * [`fnm.sh`](./lib/fnm.sh): Installs Fast Node Manager from GitHub.
  * [`go.sh`](./lib/go.sh): Installs Go for your OS and arch.
  * [`homebrew.sh`](./lib/homebrew.sh): Installs Homebrew for macOS.
  * [`link.sh`](./lib/link.sh): Recursively symlinks files.
  * [`magick.sh`](./lib/magick.sh): Installs ImageMagick from GitHub.
  * [`nerdfont.sh`](./lib/nerdfont.sh): Installs a Nerdfont.
  * [`rust.sh`](./lib/rust.sh): Installs Rust via Rustup for your OS and arch.
  * [`sudoers.sh`](./lib/sudoers.sh): Adds a user to the sudoers file.
  * [`user.sh`](./lib/user.sh): Creates a passwordless user.
  * [`uv.sh`](./lib/uv.sh): Installs `uv` and `uvx` from GitHub.

## Installation

```sh
git clone https://gh.aef.me/dotfiles.git
./dotfiles/install.sh
```

## Usage

### Secrets

All shell *rc files source `~/.secrets` if it exists. This file should be a series of `export VAR=val` statements.

### Git

Most settings are in [`.config/git/config`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/git/config). The rest go in `~/.gitconfig`:

```properties
[user]
	name = <your_name>
	email = <your_email>
	signingkey = <your_key>
[commit]
	gpgsign = true
```

See the [`git config`](https://git-scm.com/docs/git-config#FILES) docs for how the files are resolved.

### GPG

_GNU Privacy Guard_ is the de facto implementation of the OpenPGP (Pretty Good Privacy) standard. This is how I use it to sign commits.

#### Generate a key

```sh
# install gnupg if necessary
sudo apt install -y gnupg

# you'll be asked a few questions, respond with:
#   1. RSA and RSA
#   2. 4096
#   3. 0 (does not expire)
# then enter your full name and email address; passphrase can be left empty
gpg --full-generate-key

# this command prints the ID of the key associated with your email address
# you can also use the fingerprint, which is a hash of the public key
gpg --list-keys --with-colons $YOUR_EMAIL | tr ' ' '\n' | grep '^pub' | cut -d':' -f5

# the armor flag outputs ASCII (text) instead of binary ("ASCII armor")
# add your email in a comment so you know what the key is for
gpg --armor --comment $YOUR_EMAIL --export $YOUR_EMAIL > your.pub.key
gpg --armor --comment $YOUR_EMAIL --export-secret-keys $YOUR_EMAIL > your.sec.key
```

#### Import a key

If you just made the key, then it is already in the keychain of the computer you made it on. Here's how to import the secret key everywhere else:

```sh
cat your.sec.key | gpg --import
```

Now you have to _trust_ the key so you can sign with it:

```sh
# get the 16-digit key ID again
YOUR_KEY=$(gpg --list-keys --with-colons $YOUR_EMAIL | tr ' ' '\n' | grep '^pub' | cut -d':' -f5)

# enter the following:
#   1. trust (type out the word "trust")
#   2. 5
#   3. y
#   4. quit
gpg --edit-key $YOUR_KEY
```

#### Sign commits

Put this in `~/.gitconfig`:

```properties
[commit]
	gpgsign = true
```

Finally, you need to let GitHub know about your key. You can do it through the website or `gh` if you have the **GPG scope** on your token.

```sh
gh gpg-key add /path/to/your.pub.key
```

#### Windows

The steps are similar to Linux, but you need to install [Gpg4win](https://www.gpg4win.org). Here's how to get the key ID:

```powershell
$yourKey = gpg --list-keys --with-colons $YOUR_EMAIL |
Where-Object { $_.StartsWith('pub:') } |
ForEach-Object { ($_ -split ':')[4] }
```

## Inspiration

* [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)
* [holman/dotfiles](https://github.com/holman/dotfiles)
