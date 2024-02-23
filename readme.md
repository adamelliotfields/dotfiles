<div align="center">
  <!-- Illustration of an underwater haven where the sand is etched with bright, neon circuit motifs. Schools of robot-like fish with a metallic luster navigate amidst fluorescent marine plants. A radiant shell opens, standing out as a guiding light for the marine tech realm. -->
  <img src="./dotfiles.jpg" width="360" height="270" alt="A digital world with a shell and fish" />
  <h1><code>dotfiles</code></h1>
</div>

_Dotfiles_ are your configuration files used to personalize Unix-like systems. This repository also contains the Bash scripts for installing my dotfiles as well as additional software and tools.

See [dotfiles.github.io](https://dotfiles.github.io) for more on dotfiles as well as popular tools and example repos to explore. In Codespaces, GitHub will automatically clone and run the [`install.sh`](./install.sh) script, so your terminal experience will be exactly like you're used to ([docs](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles)).

_Looking to simply sync settings across computers? See [lra/mackup](https://github.com/lra/mackup) or [twpayne/chezmoi](https://github.com/twpayne/chezmoi). Manage symlinks? See [GNU Stow](https://gnu.org/software/stow)._

### Installation

```sh
git clone https://gh.aef.me/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The `install.sh` script calls the functions in [`lib`](./lib/). This folder contains scripts to perform individual tasks. It is inspired by the old Microsoft dev container [script **lib**rary](https://github.com/microsoft/vscode-dev-containers/tree/main/script-library) (now [_"features"_](https://github.com/devcontainers/features)).

  * [`apt.sh`](./lib/apt.sh)
  * [`bun.sh`](./lib/bun.sh)
  * [`chsh.sh`](./lib/chsh.sh)
  * [`clean.sh`](./lib/clean.sh)
  * [`clone.sh`](./lib/clone.sh)
  * [`deb.sh`](./lib/deb.sh)
  * [`deno.sh`](./lib/deno.sh)
  * [`fish.sh`](./lib/fish.sh)
  * [`go.sh`](./lib/go.sh)
  * [`homebrew.sh`](./lib/homebrew.sh)
  * [`link.sh`](./lib/link.sh)
  * [`nerdfont.sh`](./lib/nerdfont.sh)
  * [`nvm.sh`](./lib/nvm.sh)
  * [`python.sh`](./lib/python.sh)
  * [`rustup.sh`](./lib/rustup.sh)
  * [`sudoers.sh`](./lib/sudoers.sh)

For example:

```sh
# install bun for your OS and arch
./lib/bun.sh

# install pyenv from GitHub with Python 3.11.6 (and pipx/poetry) using `source`
source lib/python.sh ; dotfiles_python 3.11.6
```

### Fish

I :heart: [Fish](https://fishshell.com). The language is more expressive than Bash and the shell is designed for interactivity.

![A demo of Fish shell](./fish.gif)

These are some of the [functions](https://fishshell.com/docs/current/tutorial.html#autoloading-functions) I've written:

* [`chat`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/chat.fish) - OpenAI/Perplexity API Chat CLI
* [`drac`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/drac.fish) - Dracula Pro theme switcher for Hyper
* [`fio`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/fio.fish) - [file.io](https://file.io) CLI
* [`fish_prompt`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/fish_prompt.fish) - My custom prompt 🐠
* [`gituser`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/gituser.fish) - Update `~/.gitconfig` with email address and corresponding GPG key
* [`goog`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/goog.fish) - Open various Google pages with params
* [`mkcd`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/mkcd.fish) - Make a directory and change into it
* [`nvm`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/nvm.fish) - NVM proxy via [replay](https://github.com/jorgebucaran/replay.fish)
* [`postgres`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/postgres.fish) - Run a Postgres [container](https://hub.docker.com/_/postgres)
* [`pypi`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/pypi.fish) - Search PyPI for package information
* [`redis`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/redis.fish) - Run a Redis Stack [container](https://hub.docker.com/r/redis/redis-stack) with RedisInsight web GUI
* [`ubuntu`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/ubuntu.fish) - Run an Ubuntu [container](https://github.com/devcontainers/images/tree/main/src/base-ubuntu) mounted to the current directory
* [`up`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/fish/functions/up.fish) - Move up $n$ directories

### Git

Most is in [`.config/git/config`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/.config/git/config). The rest goes in `~/.gitconfig`:

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

_GNU Privacy Guard_ is the de facto implementation of the OpenPGP (Pretty Good Privacy) standard. I use it so my Git commits are signed by my email address.

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

### Python

I use [`pyenv`](https://github.com/pyenv/pyenv) because it's like `nvm` and [`pipx`](https://github.com/pypa/pipx) because it's like `npx`.

For package managers, I use [`poetry`](https://github.com/python-poetry/poetry) and [`mamba`](https://github.com/conda-forge/miniforge).

```sh
# install pyenv, pipx, and python
./lib/python.sh

# install poetry
pipx install poetry

# install mamba
bash -c "$(curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh) -b -p $HOME/.miniforge3"
```

### Secrets

All shell RC files source `~/.secrets` if it exists. This file should be a series of `export VAR=val` statements. Not in Git obvi.

### VHS

Use [`vhs`](https://github.com/charmbracelet/vhs) to create terminal screen recordings using [code](./fish.tape). The [`base-ubuntu`](https://github.com/devcontainers/images/tree/main/src/base-ubuntu) dev container image requires some additional packages to install:

```sh
# install ffmpeg and dependencies
sudo apt install -y ffmpeg libnss3-dev libatk-bridge2.0-0 libcups2 libxcomposite-dev libxdamage-dev

# use gh cli to download
gh -R charmbracelet/vhs release download -p '*Linux_x86_64.tar.gz'
gh -R tsl0922/ttyd release download -p 'ttyd.x86_64' -O ttyd

# extract and move binaries
tar -xzf vhs_*_Linux_x86_64.tar.gz
sudo mv vhs /usr/local/bin
sudo mv ttyd /usr/local/bin
sudo chmod +x /usr/local/bin/vhs
sudo chmod +x /usr/local/bin/ttyd

# cleanup
rm -f vhs_*_Linux_x86_64.tar.gz

# create `fish.gif` (downloads chromium first time)
vhs fish.tape
```

### Inspiration

* [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)
* [holman/dotfiles](https://github.com/holman/dotfiles)
* [dotphiles/dotphiles](https://github.com/dotphiles/dotphiles)
* [alexanderepstein/bash-snippets](https://github.com/alexanderepstein/Bash-Snippets)
