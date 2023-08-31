![dotfiles](./dotfiles.jpg)

## Usage

```sh
git clone https://github.com/adamelliotfields/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

## Functions

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
  * [`dotfiles_pyenv`](./lib/pyenv.sh)
  * [`dotfiles_rustup`](./lib/rustup.sh)
  * [`dotfiles_sudoers`](./lib/sudoers.sh)

In Fish you just need to run them via `replay`:

```fish
# assuming you cloned to ~/.dotfiles and you want to install deno
replay "source $HOME/.dotfiles/lib/deno.sh ; dotfiles_deno"
```

## Git

> [!NOTE]
> I use a single GitHub account for personal projects and work. My Git setup allows for quick toggling of the email address and GPG key used for signing commits.

I use 2 Git config files:
  1. [`~/.config/git/config`](./shared/.config/git/config) - global read-only config
  2. `~/.gitconfig` - global user config (Git-ignored)

When you run `git config --global`, it won't write to `~/.config/git/config` if `~/.gitconfig` exists. This mechanism makes it convenient for the latter to store "dynamic" information like email address and GPG key.

For managing the _user_ config, I created [`gituser.fish`](./mac/.config/fish/functions/gituser.fish), which updates `~/.gitconfig` with the provided email address and the corresponding GPG key. You can also call [`fzgu`](./mac/.config/fish/conf.d/abbreviations.fish) to interactively select a Git user powered by `fzf`.

A sample `~/.gitconfig` looks like this:

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

## Games

> “Some men see things as they are and ask why. Others dream things that never were and ask **_why not_**.” ― [George Bernard Shaw](https://www.goodreads.com/quotes/3544293-some-men-see-things-as-they-are-and-ask-why)

Terminal games you can install with `apt` :joystick:

* `bsdgames` - classic games
* `vitetris` - tetris clone
* `pacman4console` - pacman clone
* `ninvaders` - space invaders clone
* `nudoku` - sudoku clone
* `nsnake` - snake clone
* `greed` - clone of snake-like DOS game
* `moon-buggy` - 2d platformer

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
