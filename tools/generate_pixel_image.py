import random

# Define the size of the image
width = 640
height = 480

# Define the output file name
output_file = "image.txt"

# Open the file in text write mode
with open(output_file, "w") as f:
    for _ in range(height):
        for _ in range(width):
            # Generate a random 3-bit pixel value as a binary string
            pixel_value = format(random.randint(0, 7), '03b')
            # Write the 3-bit value to the file
            f.write(pixel_value + "\n")

print(f"Text file '{output_file}' generated successfully.")

