![dotfiles](./dotfiles.jpg)

## Usage

```sh
git clone https://github.com/adamelliotfields/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

The _functions_ in [`functions`](./functions) can be used individually, too.

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