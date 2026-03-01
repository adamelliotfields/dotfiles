# Fonts

How to patch [MonoLisa](https://www.monolisa.dev) with [Nerd Font](https://www.nerdfonts.com) glyphs.

## Install `fontforge`

```sh
sudo wget https://github.com/fontforge/fontforge/releases/download/20251009/FontForge-2025-10-09-Linux-x86_64.AppImage -qO /usr/local/bin/fontforge
sudo chmod +x /usr/local/bin/fontforge
```

## Clone `monolisa-nerdfont-patch`

```sh
git clone --depth 1 https://github.com/daylinmorgan/monolisa-nerdfont-patch.git
```

## Patch MonoLisa

```sh
unzip MonoLisa-Complete-stable.zip -d monolisa-nerdfont-patch/MonoLisa
cd monolisa-nerdfont-patch
make
```

## Install patched fonts

```sh
mkdir -p ~/.local/share/fonts
cp ./patched/ttf/*.ttf ~/.local/share/fonts
fc-cache -f -v
```
