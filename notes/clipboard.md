# Clipboard

> [!NOTE]
> This assumes X11 not Wayland.

On a Mac, you can simply use `pbcopy` and `pbpaste`.

On Linux, you need to install either `xsel` (preferred) or `xclip`:

```sh
sudo apt install -y xsel
```

To copy:

```sh
xsel --clipboard --input
xclip -selection clipboard
```

To paste:

```sh
xsel --clipboard --output
xclip -selection clipboard -o
```

The `nano` text editor uses its own buffer, but `micro` supports `xsel` and `xclip` via the [`clipper`](https://github.com/zyedidia/clipper) module.
