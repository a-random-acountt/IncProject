#!/usr/bin/env python3
"""Regenerates the Void app icon: a dark "event horizon" mark in the
app's accent violet. Requires Pillow (`pip install Pillow`).

    python3 Scripts/generate_app_icon.py
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SIZE = 1024
CX, CY = SIZE / 2, SIZE / 2
OUTPUT = Path(__file__).resolve().parent.parent / "Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png"


def hex_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


BG_TOP = hex_rgb("14101f")
BG_BOTTOM = hex_rgb("07070b")
GLOW = hex_rgb("7C6FFF")
RING = hex_rgb("EDEAFF")


def main() -> None:
    img = Image.new("RGB", (SIZE, SIZE))
    px = img.load()
    for y in range(SIZE):
        t = y / (SIZE - 1)
        r = round(BG_TOP[0] * (1 - t) + BG_BOTTOM[0] * t)
        g = round(BG_TOP[1] * (1 - t) + BG_BOTTOM[1] * t)
        b = round(BG_TOP[2] * (1 - t) + BG_BOTTOM[2] * t)
        for x in range(SIZE):
            px[x, y] = (r, g, b)

    # Soft radial glow behind the ring.
    glow_layer = Image.new("L", (SIZE, SIZE), 0)
    glow_radius = 300
    ImageDraw.Draw(glow_layer).ellipse(
        [CX - glow_radius, CY - glow_radius, CX + glow_radius, CY + glow_radius],
        fill=255,
    )
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(90))
    glow_rgb = Image.new("RGB", (SIZE, SIZE), GLOW)
    img = Image.composite(glow_rgb, img, glow_layer.point(lambda p: int(p * 0.55)))

    # A small solid "event horizon" disc.
    core_radius = 150
    ImageDraw.Draw(img, "RGBA").ellipse(
        [CX - core_radius, CY - core_radius, CX + core_radius, CY + core_radius],
        fill=(5, 5, 8, 255),
    )

    # The ring.
    ring_outer, ring_inner = 190, 172
    mask = Image.new("L", (SIZE, SIZE), 0)
    mdraw = ImageDraw.Draw(mask)
    mdraw.ellipse([CX - ring_outer, CY - ring_outer, CX + ring_outer, CY + ring_outer], fill=255)
    mdraw.ellipse([CX - ring_inner, CY - ring_inner, CX + ring_inner, CY + ring_inner], fill=0)
    img = Image.composite(Image.new("RGB", (SIZE, SIZE), RING), img, mask)

    # A faint second, larger ring for a bit of depth.
    ring2_outer, ring2_inner = 230, 222
    mask2 = Image.new("L", (SIZE, SIZE), 0)
    m2 = ImageDraw.Draw(mask2)
    m2.ellipse([CX - ring2_outer, CY - ring2_outer, CX + ring2_outer, CY + ring2_outer], fill=90)
    m2.ellipse([CX - ring2_inner, CY - ring2_inner, CX + ring2_inner, CY + ring2_inner], fill=0)
    img = Image.composite(Image.new("RGB", (SIZE, SIZE), RING), img, mask2)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUTPUT, "PNG")
    print(f"Wrote {OUTPUT} ({img.size[0]}x{img.size[1]})")


if __name__ == "__main__":
    main()
