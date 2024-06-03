#!/usr/bin/env python3

from sys import argv

fname = argv[1]

with open(fname, "r") as fh:
    address = 0  # Initialize the address counter
    for line in fh:
        line = line.rstrip()
        line_int = int(line, 2)
        decoded_char = chr(line_int)
        if decoded_char != '\n':  # Skip newline characters
            binary_address = format(address, 'b')  # Convert address to binary
            print(f"'{binary_address}': {decoded_char}")
            address += 1  # Increment the address counter
print("END")

