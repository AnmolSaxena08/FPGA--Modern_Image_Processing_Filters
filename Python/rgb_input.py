from PIL import Image
import numpy as np

# -------------------------------
# Configuration
# -------------------------------
INPUT_IMAGE  = "input.jpg"      # selfie / real image
OUTPUT_TEXT  = "image_rgb.txt"  # text file for Verilog
WIDTH  = 512
HEIGHT = 512

# -------------------------------
# Load image
# -------------------------------
img = Image.open(INPUT_IMAGE).convert("RGB")

# Resize to match hardware pipeline
img = img.resize((WIDTH, HEIGHT), Image.BILINEAR)

pixels = np.array(img, dtype=np.uint8)

# -------------------------------
# Write RGB values
# -------------------------------
with open(OUTPUT_TEXT, "w") as f:
    for y in range(HEIGHT):
        for x in range(WIDTH):
            r, g, b = pixels[y, x]
            f.write(f"{r} {g} {b}\n")

print("RGB image successfully converted to text.")
print(f"Resolution: {WIDTH} x {HEIGHT}")
print("Format: R G B per line")
