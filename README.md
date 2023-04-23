![dotfiles](./dotfiles.jpg)

## Usage

```sh
git clone https://github.com/adamelliotfields/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

The [`functions`](./functions) can be used individually, too.

```bash
source ~/.dotfiles/functions

# install the deb for diskus from GitHub Releases
df_deb sharkdp/diskus

# install the asdf version manager with the node and deno plugins
df_asdf nodejs deno

# install nvm and node
df_nvm

# install deno from GitHub Releases
df_deno

# install go from golang.org
df_go

# install rust via rustup
df_rust
```

## Git

I use 2 Git config files:
  1. [`~/.config/git/config`](./shared/.config/git/config) - global read-only config
  2. `~/.gitconfig` - global user config

When you run `git config --global`, it won't write to `~/.config/git/config` if `~/.gitconfig` exists. This mechanism makes it convenient for the latter to store "dynamic" information like email address and GPG key.

For managing the user config, I created [`git_user.fish`](./mac/.config/fish/functions/git_user.fish).

A sample `~/.gitconfig` looks like this:

> _NB: **name** and **email** are required; everything else is optional._

```properties
[user]
	name = <your_name>
	email = <your_email>
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

* [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles) :fire:
* [dotphiles/dotphiles](https://github.com/dotphiles/dotphiles)
* [lra/mackup](https://github.com/lra/mackup)
* [GitHub Does Dotfiles](https://dotfiles.github.io)
* [Personalizing GitHub Codespaces for your account](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles)
* [Chezmoi](https://chezmoi.io)
* [GNU Stow](https://gnu.org/software/stow)
