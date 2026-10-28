#!/usr/bin/env python3
"""Generate Zazzu's dark-red / black forensic workstation wallpaper.

Usage: generate-wallpaper.py [output.png] [width] [height]
Requires python-pillow. Deterministic: the same input always renders the
same wallpaper.
"""
from __future__ import annotations

import math
import random
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

W, H = 3840, 2160
BG = (5, 5, 5)
RED = (179, 18, 42)
RED_HOT = (224, 48, 74)
RED_DIM = (74, 10, 18)
TEXT = (214, 214, 214)
GRID = (30, 7, 10)

FONT_REG = "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"
FONT_BOLD = "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Bold.ttf"
FONT_FALLBACK = "/usr/share/fonts/TTF/DejaVuSansMono.ttf"


def font(path: str, size: int) -> ImageFont.FreeTypeFont:
    for candidate in (path, FONT_FALLBACK):
        try:
            return ImageFont.truetype(candidate, size)
        except OSError:
            pass
    return ImageFont.load_default()


def vertical_gradient(size: tuple[int, int], top: tuple[int, int, int], bottom: tuple[int, int, int]) -> Image.Image:
    w, h = size
    strip = Image.new("RGB", (1, h))
    px = strip.load()
    for y in range(h):
        t = y / max(h - 1, 1)
        px[0, y] = tuple(round(top[i] * (1 - t) + bottom[i] * t) for i in range(3))
    return strip.resize((w, h))


def radial_glow(size: tuple[int, int], center: tuple[int, int], radius: int, color: tuple[int, int, int], opacity: float) -> Image.Image:
    w, h = size
    mask = Image.new("L", (w, h), 0)
    d = ImageDraw.Draw(mask)
    steps = 120
    for i in range(steps, 0, -1):
        t = i / steps
        r = int(radius * t)
        alpha = int(255 * opacity * (1 - t) ** 2.4)
        d.ellipse((center[0] - r, center[1] - r, center[0] + r, center[1] + r), fill=alpha)
    mask = mask.filter(ImageFilter.GaussianBlur(radius // 8))
    layer = Image.new("RGBA", (w, h), (*color, 255))
    layer.putalpha(mask)
    return layer


def add_grid(img: Image.Image) -> None:
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    step = 96
    for x in range(0, W, step):
        d.line((x, 0, x, H), fill=(*GRID, 90), width=1)
    for y in range(0, H, step):
        d.line((0, y, W, y), fill=(*GRID, 90), width=1)
    # Heavier major grid.
    for x in range(0, W, step * 4):
        d.line((x, 0, x, H), fill=(*GRID, 150), width=2)
    for y in range(0, H, step * 4):
        d.line((0, y, W, y), fill=(*GRID, 150), width=2)
    img.alpha_composite(layer)


def add_big_z(img: Image.Image) -> None:
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    f = font(FONT_BOLD, 1450)
    text = "Z"
    box = d.textbbox((0, 0), text, font=f)
    tw, th = box[2] - box[0], box[3] - box[1]
    x = 420 - box[0]
    y = 320 - box[1]
    d.text((x, y), text, font=f, fill=(*RED_DIM, 124), stroke_width=2, stroke_fill=(*RED, 90))
    layer = layer.filter(ImageFilter.GaussianBlur(1.2))
    img.alpha_composite(layer)


def add_hex_dump(img: Image.Image) -> None:
    rng = random.Random(0x7A22)
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    f = font(FONT_REG, 25)
    x0, y0 = 2440, 1320
    line_h = 39
    rows = 17
    for r in range(rows):
        addr = 0x00401000 + r * 16
        data = " ".join(f"{rng.randrange(256):02x}" for _ in range(8))
        ascii_part = "".join(chr(rng.choice([0x2e, 0x2f, 0x5c, 0x7c, 0x5f, 0x2d])) for _ in range(8))
        alpha = 120 if r % 3 else 170
        d.text((x0, y0 + r * line_h), f"{addr:08x}  {data}  {ascii_part}", font=f, fill=(*RED_DIM, alpha))
    d.text((x0, y0 - 46), "00401000  .text  //  entropy 7.41", font=font(FONT_BOLD, 21), fill=(*RED, 190))
    img.alpha_composite(layer)


def add_binary_columns(img: Image.Image) -> None:
    rng = random.Random(0xB16B00B5)
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    f = font(FONT_REG, 20)
    for col in range(14):
        x = 190 + col * 54
        y = 226 + rng.randrange(0, 200)
        length = rng.randrange(5, 17)
        for row in range(length):
            bit = rng.choice("01")
            alpha = max(28, 120 - row * 6)
            d.text((x, y + row * 25), bit, font=f, fill=(*RED, alpha))
    img.alpha_composite(layer)


def add_ecg(img: Image.Image) -> None:
    rng = random.Random(1701)
    baseline = 1240
    points: list[tuple[int, int]] = []
    x = 190
    phase = 0.0
    while x < W - 190:
        # Mostly flat with a sharp QRS complex every ~430 px.
        p = (x - 190) % 430
        if p < 300:
            y = baseline + int(7 * math.sin(x / 55.0))
        elif p < 322:
            y = baseline + 18
        elif p < 332:
            y = baseline - 150
        elif p < 342:
            y = baseline + 100
        elif p < 358:
            y = baseline - 28
        else:
            y = baseline + int(7 * math.sin(x / 55.0))
        points.append((x, y))
        x += 3
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.line(points, fill=(*RED, 210), width=8, joint="curve")
    glow = glow.filter(ImageFilter.GaussianBlur(22))
    img.alpha_composite(glow)
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.line(points, fill=(*RED_HOT, 230), width=3, joint="curve")
    # Pulse marker at the last beat.
    last = points[-1]
    d.ellipse((last[0] - 7, last[1] - 7, last[0] + 7, last[1] + 7), fill=(*RED_HOT, 255))
    img.alpha_composite(layer)


def add_radar(img: Image.Image) -> None:
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = 1080, 700
    for r in (180, 320, 470, 640):
        d.ellipse((cx - r, cy - r, cx + r, cy + r), outline=(*RED, 42), width=2)
    d.line((cx - 700, cy, cx + 700, cy), fill=(*RED, 38), width=1)
    d.line((cx, cy - 700, cx, cy + 700), fill=(*RED, 38), width=1)
    for angle in range(0, 360, 30):
        rad = math.radians(angle)
        r1, r2 = 620, 650
        d.line((cx + r1 * math.cos(rad), cy + r1 * math.sin(rad), cx + r2 * math.cos(rad), cy + r2 * math.sin(rad)), fill=(*RED, 60), width=2)
    img.alpha_composite(layer)


def add_corner_text(img: Image.Image) -> None:
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    f_small = font(FONT_BOLD, 23)
    f_big = font(FONT_BOLD, 35)
    d.text((190, 150), "ZAZZU // SECURE WORKSTATION", font=f_small, fill=(*RED, 200))
    d.line((190, 190, 740, 190), fill=(*RED, 160), width=2)
    d.text((190, 202), "malware analysis  ·  reverse engineering  ·  threat intel", font=font(FONT_REG, 20), fill=(*TEXT, 95))
    d.text((W - 1000, H - 140), "zazzu@arch", font=f_big, fill=(*TEXT, 170))
    d.text((W - 1000, H - 91), "dark red on black  //  no safe harbor for bad code", font=font(FONT_REG, 19), fill=(*RED, 160))
    img.alpha_composite(layer)


def add_scanlines(img: Image.Image) -> None:
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    for y in range(0, H, 4):
        d.line((0, y, W, y), fill=(0, 0, 0, 18))
    img.alpha_composite(layer)


def vignette(img: Image.Image) -> Image.Image:
    mask = Image.new("L", (W, H), 0)
    d = ImageDraw.Draw(mask)
    d.ellipse((-W * 0.25, -H * 0.35, W * 1.25, H * 1.35), fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(280))
    dark = Image.new("RGB", (W, H), (0, 0, 0))
    return Image.composite(img, dark, mask)


def main() -> None:
    out = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "config/hypr/wallpapers/zazzu-dark-red.png"
    global W, H
    if len(sys.argv) >= 4:
        W, H = int(sys.argv[2]), int(sys.argv[3])

    img = vertical_gradient((W, H), (2, 2, 2), (9, 2, 4)).convert("RGBA")
    img.alpha_composite(radial_glow((W, H), (int(W * 0.26), int(H * 0.48)), int(W * 0.48), (58, 5, 12), 0.65))
    img.alpha_composite(radial_glow((W, H), (int(W * 0.78), int(H * 0.70)), int(W * 0.30), (42, 3, 8), 0.38))
    add_grid(img)
    add_radar(img)
    add_big_z(img)
    add_binary_columns(img)
    add_hex_dump(img)
    add_ecg(img)
    add_corner_text(img)
    add_scanlines(img)
    img = vignette(img)

    out.parent.mkdir(parents=True, exist_ok=True)
    img.convert("RGB").save(out, "PNG", optimize=True)
    print(out)


if __name__ == "__main__":
    main()
