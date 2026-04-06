# ROCm in WSL

## Bootstrap

Get the latest deb from the [install Radeon](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installrad/wsl/install-radeon.html) page.

```sh
wget https://repo.radeon.com/amdgpu-install/7.2/ubuntu/noble/amdgpu-install_7.2.70200-1_all.deb
sudo dpkg -i amdgpu-install_7.2.70200-1_all.deb
```

## Install ROCm

Don't install the `graphics` usecase or kernel modules (`--no-dkms`) in WSL.

```sh
amdgpu-install --usecase=wsl,rocm --no-dkms
```

## Install librocdxg

Get the latest release from [GitHub](https://github.com/ROCm/librocdxg/releases).

```sh
wget https://github.com/ROCm/librocdxg/releases/download/v1.1.1/rocdxg-roct_1.1.1_amd64.deb
sudo dpkg -i rocdxg-roct_1.1.1_amd64.deb
export HSA_ENABLE_DXG_DETECTION=1
rocminfo  # verify
```

## Install PyTorch

Get the latest wheels from the [install PyTorch](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installrad/native_linux/install-pytorch.html) page.

Put your base dependencies in `requirements.txt` and create separate `requirements-cpu.txt` and `requirements-rocm.txt` files.

```
# requirements.txt
accelerate
diffusers
hf-transfer
transformers
```

```
# requirements-cpu.txt
-r requirements.txt
torch==2.9.1
torchaudio==2.9.1
torchvision==0.24.0
triton==3.5.1
```

```
# requirements-rocm.txt
-r requirements.txt
torch @ https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/torch-2.9.1%2Brocm7.2.0.lw.git7e1940d4-cp312-cp312-linux_x86_64.whl
torchvision @ https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/torchvision-0.24.0%2Brocm7.2.0.gitb919bd0c-cp312-cp312-linux_x86_64.whl
torchaudio @ https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/torchaudio-2.9.0%2Brocm7.2.0.gite3c6ee2b-cp312-cp312-linux_x86_64.whl
triton @ https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/triton-3.5.1%2Brocm7.2.0.gita272dfa8-cp312-cp312-linux_x86_64.whl
```

## Smoke test

```py
#!/usr/bin/env python3
import os
import sys
import time
from pathlib import Path

import torch
from diffusers import DiffusionPipeline

PROMPT = "Colorful noise"
MODEL_ID = "hf-internal-testing/tiny-stable-diffusion-pipe"
OUTPUT_PATH = Path(__file__).with_name("output.png")


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    print(f"HSA_ENABLE_DXG_DETECTION={os.environ.get('HSA_ENABLE_DXG_DETECTION')}")
    print(f"torch={torch.__version__}")
    print(f"torch.version.hip={torch.version.hip}")
    print(f"torch.cuda.is_available()={torch.cuda.is_available()}")
    print(f"torch.cuda.device_count()={torch.cuda.device_count()}")

    if not torch.cuda.is_available():
        fail("ROCm/HIP device is not available to PyTorch.")

    device = torch.device("cuda")
    device_name = torch.cuda.get_device_name(0)
    dtype = torch.float16

    print(f"device={device}")
    print(f"device_name={device_name}")
    print(f"dtype={dtype}")

    pipe = DiffusionPipeline.from_pretrained(MODEL_ID, torch_dtype=dtype)
    pipe.set_progress_bar_config(disable=True)
    pipe.enable_attention_slicing()
    pipe.safety_checker = None
    pipe.requires_safety_checker = False
    pipe = pipe.to(device)
    unet_device = next(pipe.unet.parameters()).device
    text_encoder_device = next(pipe.text_encoder.parameters()).device
    vae_device = next(pipe.vae.parameters()).device

    print(f"unet_device={unet_device}")
    print(f"text_encoder_device={text_encoder_device}")
    print(f"vae_device={vae_device}")

    if unet_device.type != "cuda":
        fail("Diffusers pipeline did not move the UNet to the GPU.")

    start = time.perf_counter()
    image = pipe(
        PROMPT,
        num_inference_steps=2,
        guidance_scale=0.0,
        generator=torch.Generator(device="cpu").manual_seed(0),
    ).images[0]
    torch.cuda.synchronize()
    elapsed = time.perf_counter() - start

    image.save(OUTPUT_PATH)
    print(f"generated_image={OUTPUT_PATH}")
    print(f"image_size={image.size}")
    print(f"generation_elapsed={elapsed:.2f}s")


if __name__ == "__main__":
    main()
```
