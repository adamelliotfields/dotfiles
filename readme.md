<div align="center">
  <!-- Illustration of an underwater haven where the sand is etched with bright, neon circuit motifs. Schools of robot-like fish with a metallic luster navigate amidst fluorescent marine plants. A radiant shell opens, standing out as a guiding light for the marine tech realm. -->
  <img src="./dotfiles.jpg" width="360" height="270" alt="A digital world with a shell and fish" />
  <h1><code>dotfiles</code></h1>
  <p>My configuration files and shell scripts.</p>
</div>

## Notes

### Installation

The [`install`](./install) script calls the functions in [`lib`](./lib/):
  * [`dotfiles_apt`](./lib/apt.sh)
  * [`dotfiles_chsh`](./lib/chsh.sh)
  * [`dotfiles_clone`](./lib/clone.sh)
  * [`dotfiles_deb`](./lib/deb.sh)
  * [`dotfiles_deno`](./lib/deno.sh)
  * [`dotfiles_go`](./lib/go.sh)
  * [`dotfiles_homebrew`](./lib/homebrew.sh)
  * [`dotfiles_link`](./lib/link.sh)
  * [`dotfiles_nvm`](./lib/nvm.sh)
  * [`dotfiles_python`](./lib/python.sh)
  * [`dotfiles_rustup`](./lib/rustup.sh)
  * [`dotfiles_sudoers`](./lib/sudoers.sh)

### Git

Most is in [`git/config`](https://github.com/adamelliotfields/dotfiles/blob/main/shared/git/config), the rest goes in `~/.gitconfig`:

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
[gpg]
	program = /path/to/gpg
```

### Fish

Fish has an [autoloading](https://fishshell.com/docs/current/tutorial.html#autoloading-functions) feature that makes it very easy to customize your shell with functions:
* [`drac`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/drac.fish) - Dracula Pro theme switcher for Hyper
* [`fgpt`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/fgpt.fish) - OpenAI GPT CLI
* [`fish_prompt`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/fish_prompt.fish) - My custom prompt 🐠
* [`gituser`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/gituser.fish) - Update `~/.gitconfig` with email address and corresponding GPG key
* [`goog`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/goog.fish) - Open various Google pages with params
* [`mkcd`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/mkcd.fish) - Make a directory and change into it
* [`nvm`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/nvm.fish) - NVM proxy via [replay](https://github.com/jorgebucaran/replay.fish)
* [`postgres`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/postgres.fish) - Run a Postgres [container](https://hub.docker.com/_/postgres)
* [`pypi`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/pypi.fish) - Search PyPI for package information
* [`redis`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/redis.fish) - Run a Redis Stack [container](https://hub.docker.com/r/redis/redis-stack) with RedisInsight web GUI
* [`ubuntu`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/ubuntu.fish) - Run an Ubuntu [container](https://github.com/devcontainers/images/tree/main/src/base-ubuntu) mounted to the current directory
* [`up`](https://github.com/adamelliotfields/dotfiles/blob/main/mac/.config/fish/functions/up.fish) - Move up $n$ directories

## References

* [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)
* [holman/dotfiles](https://github.com/holman/dotfiles)
* [dotphiles/dotphiles](https://github.com/dotphiles/dotphiles)
* [alexanderepstein/bash-snippets](https://github.com/alexanderepstein/Bash-Snippets)
* [lra/mackup](https://github.com/lra/mackup)
* [GitHub Does Dotfiles](https://dotfiles.github.io)
* [Personalizing GitHub Codespaces for your account](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles)
* [Chezmoi](https://chezmoi.io)
* [GNU Stow](https://gnu.org/software/stow)
