from PIL import Image

# Load the image
input_path = "sample.jpg"   # replace with your image path
output_path = "input.jpg"

# Open the image
img = Image.open(input_path)

# Resize the image to 512x512
resized_img = img.resize((512, 512))

# Save the resized image
resized_img.save(output_path)

print("Image resized to 512x512 and saved!")