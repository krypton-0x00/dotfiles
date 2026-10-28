# Hyprland vmwgfx DMA-BUF patch (VMware guests only)

GPU-accelerated Wayland clients (kitty, alacritty, Chromium, Electron apps)
are killed by Hyprland inside a VMware guest even with 3D acceleration on:

```
[glfw error 65544]: Wayland: fatal display error: Broken pipe
wl_display#1: error 1: invalid arguments for wl_surface#39.attach
```

## Why

`vmwgfx` overrides `drm_prime_fd_to_handle()` and returns a **TTM surface
handle** for guest-backed surfaces instead of a GEM handle. Hyprland then
calls `drmCloseBufferHandle()`, which only knows about GEM objects and fails
with `EINVAL`. Hyprland treats that failure as a broken DMA-BUF, rejects the
surface attach, and the client is disconnected.

The Hyprland log shows the same thing from the compositor side:

```
ERR ]: drm: drmCloseBufferHandle failed
```

This is a kernel/libdrm interface mismatch; the proper fix belongs in
`vmwgfx` or libdrm. Until then, userspace can release the handle with the
`DRM_VMW_UNREF_SURFACE` ioctl.

## What the patch does

`hyprland-vmwgfx-dmabuf.patch` touches only
`src/protocols/LinuxDMABUF.cpp`:

- if `drmCloseBufferHandle()` fails **and** the DRM driver is `vmwgfx`,
  retry with `DRM_VMW_UNREF_SURFACE`
- reject the DMA-BUF only when both paths fail

Source: <https://github.com/hyprwm/Hyprland/discussions/12966>, independently
tested against Hyprland 0.56.2.

## Usage

```sh
./apply.sh
```

The script refuses to run on non-VMware hardware, clones the Hyprland tag,
applies the patch, builds with Ninja and installs `/usr/bin/Hyprland`. The
packaged binary is backed up in `/tmp`.

Rollback:

```sh
sudo pacman -U /var/cache/pacman/pkg/hyprland-0.56.2-4-x86_64.pkg.tar.zst
```

`pacman -Qkk hyprland` will report a size mismatch for `/usr/bin/Hyprland`
while the patched binary is installed, and a Hyprland package upgrade
silently reverts the fix — rerun `apply.sh` afterwards.

## Not covered

Aquamarine's own scanout import still logs `drm: drmCloseBufferHandle failed`
when it drops a vmwgfx buffer (`CDRMFB::closeHandles()`), leaking one TTM
reference per swapchain buffer. It does not disconnect clients; patching
`libaquamarine.so` the same way is the follow-up if that leak ever shows up
in VRAM usage.
