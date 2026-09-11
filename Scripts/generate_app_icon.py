#!/usr/bin/env python3
"""Regenerates the Void app icon: a stark black-on-black "event horizon"
ring, no color, matching the app's Vercel-black theme. Requires Pillow
(`pip install Pillow`).

    python3 Scripts/generate_app_icon.py
"""
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 1024
CX, CY = SIZE / 2, SIZE / 2
OUTPUT = Path(__file__).resolve().parent.parent / "Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png"

BLACK = (0, 0, 0)
RING = (255, 255, 255)
DIM_RING = (120, 120, 120)


def main() -> None:
    img = Image.new("RGB", (SIZE, SIZE), BLACK)

    # A faint outer ring, barely there.
    ring2_outer, ring2_inner = 230, 223
    mask2 = Image.new("L", (SIZE, SIZE), 0)
    m2 = ImageDraw.Draw(mask2)
    m2.ellipse([CX - ring2_outer, CY - ring2_outer, CX + ring2_outer, CY + ring2_outer], fill=140)
    m2.ellipse([CX - ring2_inner, CY - ring2_inner, CX + ring2_inner, CY + ring2_inner], fill=0)
    img = Image.composite(Image.new("RGB", (SIZE, SIZE), DIM_RING), img, mask2)

    # The crisp white event-horizon ring.
    ring_outer, ring_inner = 188, 172
    mask = Image.new("L", (SIZE, SIZE), 0)
    mdraw = ImageDraw.Draw(mask)
    mdraw.ellipse([CX - ring_outer, CY - ring_outer, CX + ring_outer, CY + ring_outer], fill=255)
    mdraw.ellipse([CX - ring_inner, CY - ring_inner, CX + ring_inner, CY + ring_inner], fill=0)
    img = Image.composite(Image.new("RGB", (SIZE, SIZE), RING), img, mask)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUTPUT, "PNG")
    print(f"Wrote {OUTPUT} ({img.size[0]}x{img.size[1]})")


if __name__ == "__main__":
    main()
