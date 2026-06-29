# stable-diffusion.cpp

Diffusion model inference in pure C/C++ based on [ggml](https://github.com/ggml-org/ggml).

## Installation

Download the latest release and extract to `/opt/stable-diffusion-cpp`:

```sh
unzip sd-master.zip
cp -r build/bin /opt/stable-diffusion-cpp
```

Ensure `/opt/stable-diffusion-cpp` is in your `PATH`. See [`.exports`](../shared/.exports).

## Usage

Create [aliases](../shared/.aliases) for each model and run from the command line. Use `img2sixel` to preview images in the terminal.

## Upscaling

Get RealESRGAN x4 Plus from [Comfy-Org/Real-ESRGAN_repackaged](https://huggingface.co/Comfy-Org/Real-ESRGAN_repackaged).

You can either pass `--upscale-model` when generating or run in upscale mode on an existing image:

```sh
sd-cli -M upscale -i /path/to/input.png -o ./output_4x.png --upscale-model /path/to/realesrgan-x4plus.safetensors
```

You can then use `magick` to resize and compress the upscaled image:

```sh
magick ./output_4x.png -filter Lanczos -resize 2048x2048 -quality 90 ./output_2x.jpg
```
