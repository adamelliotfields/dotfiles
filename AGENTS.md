# dotfiles

This repository contains my dotfiles, which are configuration files for various applications and tools that I use on my computer.

The `linux`, `mac`, `shared`, and `windows` folders contain configuration files that get symlinked to their respective locations in `$HOME`.

The `notes` folder contains helpful Markdown notes for provisioning a new machine.

The `bin/dotfiles` script is a single-file Python CLI with the following commands:

```
dotfiles install bin [-f, --force] <name>
dotfiles install deb [-f, --force] <repo>
dotfiles install uv [-f, --force]
dotfiles install btop [-f, --force]
dotfiles install fish
dotfiles install go
dotfiles install rust
dotfiles install nerdfont
dotfiles install symlinks

dotfiles setup apt
dotfiles setup ssh
dotfiles setup motd
dotfiles setup user <user>
dotfiles setup sudo [-u, --user]
dotfiles setup shell [-u, --user] <shell>
```
