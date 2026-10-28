#!/usr/bin/env python3
"""Build the Zazzu-Red GTK theme from the Matrix-Dark GTK theme.

The Matrix theme is a complete, well-tested GTK3/GTK4 theme. We keep its
structure and remap its green/blue palette to black + dark red so GTK apps
match the Hyprland/Waybar theme exactly.

Usage: build-theme.py [source-theme-dir] [output-theme-dir]
"""
from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

SRC = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/usr/share/themes/Matrix-Dark")
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path(__file__).resolve().parent.parent / "theme/Zazzu-Red"

# Original -> replacement. Order matters only for readability; replacements are
# done in one pass so values never cascade into each other.
HEX = {
    "#111927": "#0a0a0a",
    "#0c121d": "#060606",
    "#1e2d48": "#141414",
    "#243656": "#1d1d1d",
    "#18243a": "#101010",
    "#2e3748": "#252525",
    "#2b3a55": "#2a2a2a",
    "#192439": "#121212",
    "#39465e": "#3a3a3a",
    "#06090e": "#000000",
    "#1a2231": "#161616",
    "#a4b1cd": "#d7d7d7",
    "#9fef00": "#c0182f",
    "#beff3d": "#e0304a",
    "#b5ff23": "#e0304a",
    "#adff0a": "#d0233d",
    "#8ed600": "#a8172c",
    "#004cff": "#7a0a16",
    "#0031a3": "#4a060d",
    "#0b81c0": "#b3122a",
    "#1c71d8": "#b3122a",
    "#2861c6": "#8f1020",
    "#2ec27e": "#d7d7d7",
    "#27a66c": "#7a0a16",
    "#cc0022": "#e0304a",
    "#7a5400": "#a86a1c",
    "#4f7208": "#b3122a",
    "#e2e8f3": "#f0f0f0",
    "#7100bb": "#6e0a14",
    "#393484": "#6e0a14",
    "#6d53e0": "#8b0000",
    "#ff2548": "#ff2548",
}

# RGB triples used inside rgba() in the CSS. Keep alpha values intact.
RGB = {
    (164, 177, 205): (215, 215, 215),
    (159, 239, 0): (192, 24, 47),
    (17, 25, 39): (10, 10, 10),
    (30, 45, 72): (20, 20, 20),
    (36, 54, 86): (29, 29, 29),
    (12, 18, 29): (6, 6, 6),
    (24, 36, 58): (16, 16, 16),
    (57, 70, 94): (58, 58, 58),
    (190, 255, 61): (224, 48, 74),
    (181, 255, 35): (224, 48, 74),
}

HEX_RE = re.compile(r"#[0-9a-fA-F]{6}\b")
RGB_RE = re.compile(r"rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(,[^)]*)?\)")

INDEX = """[Desktop Entry]
Type=X-GNOME-Metatheme
Name=Zazzu-Red
Comment=Dark red on black theme for zazzu
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=Zazzu-Red
MetacityTheme=Zazzu-Red
IconTheme=Papirus-Dark
CursorTheme=Bibata-Modern-Ice
ButtonLayout=close,minimize,maximize:menu
"""


def recolor(text: str) -> str:
    def sub_hex(m: re.Match[str]) -> str:
        return HEX.get(m.group(0).lower(), m.group(0))

    def sub_rgb(m: re.Match[str]) -> str:
        key = (int(m.group(1)), int(m.group(2)), int(m.group(3)))
        if key not in RGB:
            return m.group(0)
        r, g, b = RGB[key]
        tail = m.group(4) or ""
        fn = "rgba" if tail else "rgb"
        return f"{fn}({r}, {g}, {b}{tail})"

    return RGB_RE.sub(sub_rgb, HEX_RE.sub(sub_hex, text))


def fixups(text: str, part: str) -> str:
    """Silence invalid CSS inherited from Matrix-Dark's GTK3 sheets."""
    if part != "gtk-3.0":
        return text
    # GTK3 has no border-spacing property (GTK4 does).
    text = re.sub(r"^[ \t]*border-spacing:[^;]+;[ \t]*\n", "", text, flags=re.MULTILINE)
    # Matrix-Dark writes a shorthand value into border-color, which GTK3 rejects.
    text = re.sub(r"border-color:\s*(\d+px\s+\w+\s+#[0-9a-fA-F]{6})\s*;",
                  r"border: \1;", text)
    return text


def main() -> None:
    if not SRC.is_dir():
        raise SystemExit(f"source theme not found: {SRC}")

    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)

    for part in ("gtk-2.0", "gtk-3.0", "gtk-4.0"):
        src = SRC / part
        if src.is_dir():
            shutil.copytree(src, OUT / part)

    (OUT / "index.theme").write_text(INDEX, encoding="utf-8")

    changed = 0
    for path in OUT.rglob("*"):
        if path.is_file() and path.suffix in {".css", ".rc"}:
            text = path.read_text(encoding="utf-8", errors="replace")
            new = fixups(recolor(text), path.parent.name)
            if new != text:
                path.write_text(new, encoding="utf-8")
                changed += 1
    print(f"built {OUT} ({changed} files recolored)")


if __name__ == "__main__":
    main()
