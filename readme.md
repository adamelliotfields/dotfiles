<div align="center">
  <img src="./dotfiles.jpg" width="360" height="270" alt="A digital world with a shell and fish" />
  <h1><code>dotfiles</code></h1>
</div>

You can think of this repo as like a mini-Ansible playbook for setting up a new machine except it is pure Bash. Works on Debian and Mac.

## Installation

Linux programs I use are listed in [`install.sh`](./install.sh) while the Mac ones are in [`mac/.Brewfile`](./mac/.Brewfile).

```sh
git clone https://gh.aef.me/dotfiles.git
./dotfiles/install.sh
```

## Features

  * [`apt.sh`](./lib/apt.sh): Updates and installs Apt packages.
  * [`btop.sh`](./lib/btop.sh): Installs btop from source for GPU monitoring.
  * [`bun.sh`](./lib/bun.sh): Installs Bun with completions for your OS and arch.
  * [`chsh.sh`](./lib/chsh.sh): Sets the default shell for the current user.
  * [`clean.sh`](./lib/clean.sh): Undoes `link.sh`.
  * [`clone.sh`](./lib/clone.sh): Clones GitHub repos to `$HOME`.
  * [`deb.sh`](./lib/deb.sh): Installs Deb packages from GitHub Releases.
  * [`deno.sh`](./lib/deno.sh): Installs Deno with completions for your OS and arch.
  * [`fish.sh`](./lib/fish.sh): Installs Fish from the fish-shell PPA.
  * [`go.sh`](./lib/go.sh): Installs Go for your OS and arch.
  * [`homebrew.sh`](./lib/homebrew.sh): Installs Homebrew for macOS.
  * [`link.sh`](./lib/link.sh): Recursively symlinks files.
  * [`miniforge.sh`](./lib/miniforge.sh): Installs Miniforge for your OS and arch.
  * [`nerdfont.sh`](./lib/nerdfont.sh): Installs a Nerdfont.
  * [`node.sh`](./lib/node.sh): Installs Node LTS via NVM.
  * [`python.sh`](./lib/python.sh): Installs Python and Pipx via PyEnv.
  * [`rust.sh`](./lib/rust.sh): Installs Rust via Rustup for your OS and arch.
  * [`sudoers.sh`](./lib/sudoers.sh): Adds the current user to the sudoers file.

## Usage

### Secrets

All shell `*rc` files source `~/.secrets` if it exists. This file should be a series of `export VAR=val` statements. Git ignored.

### Git

Most settings are in [`.config/git/config`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/git/config). The rest go in `~/.gitconfig`:

```properties
[user]
	name = <your_name> # required
	email = <your_email> # required
	signingkey = <your_key>
[diff]
	tool = <smerge|code>
[merge]
	tool = <smerge|code>
[commit]
	gpgsign = true
```

See the [`git config`](https://git-scm.com/docs/git-config#FILES) docs for details on how the files are resolved.

### GPG

_GNU Privacy Guard_ is the de facto implementation of the OpenPGP (Pretty Good Privacy) standard. I use it so my Git commits are signed.

#### Generate a key

```sh
# install gnupg if necessary
# it's the same package in Homebrew
sudo apt install -y gnupg

# you'll be asked a few questions:
#   1. RSA and RSA
#   2. 4096
#   3. 0 (does not expire)
# then enter your full name and email address; passphrase can be left empty
gpg --full-generate-key

# this command prints the ID of the key associated with your email address
# (you can also use the fingerprint, which is a hash of the public key)
gpg --list-keys --with-colons $YOUR_EMAIL | tr ' ' '\n' | grep '^pub' | cut -d':' -f5

# export the keys and write them by hand on a piece of paper
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

Finally, you need to let GitHub know about your key. You can do it through the website or `gh` **if** you have GPG scope on your `GH_TOKEN`.

```sh
gh gpg-key add /path/to/your.pub.key
```

## Inspiration

* [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)
* [holman/dotfiles](https://github.com/holman/dotfiles)
