from PIL import Image
import numpy as np

# -------------------------------
# Configuration
# -------------------------------
INPUT_TEXT  = "image_rgb_out.txt"
OUTPUT_IMG  = "output_camera_filter.bmp"

WIDTH  = 512
HEIGHT = 512
TOTAL_PIXELS = WIDTH * HEIGHT

# -------------------------------
# Allocate image buffer
# -------------------------------
img_array = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)

# -------------------------------
# Read text and rebuild image
# -------------------------------
with open(INPUT_TEXT, "r") as f:
    idx = 0
    for line in f:
        if idx >= TOTAL_PIXELS:
            break

        parts = line.strip().split()
        if len(parts) != 3:
            continue

        r, g, b = map(int, parts)

        y = idx // WIDTH
        x = idx % WIDTH

        img_array[y, x, 0] = r
        img_array[y, x, 1] = g
        img_array[y, x, 2] = b

        idx += 1

# -------------------------------
# Safety check
# -------------------------------
if idx != TOTAL_PIXELS:
    print(f"WARNING: Expected {TOTAL_PIXELS} pixels, got {idx}")

# -------------------------------
# Save image
# -------------------------------
img = Image.fromarray(img_array, "RGB")
img.save(OUTPUT_IMG)

print("Reconstruction complete.")
print(f"Saved as: {OUTPUT_IMG}")
