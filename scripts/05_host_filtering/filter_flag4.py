#!/usr/bin/env python3
"""
Filter SAM alignments by SAM FLAG = 4.

This script retains only records whose SAM FLAG is equal to 4,
corresponding to sequences that did not map to the reference genome.

Usage:
    python filter_flag4.py
"""
# Input SAM file
input_file = "input.sam"

# Output SAM file containing only unmapped alignments (SAM FLAG = 4)
output_file = "filtered_flag4.sam"


with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    for line in infile:
        if line.startswith("@"):
            outfile.write(line)
            continue

        fields = line.rstrip("\n").split("\t")

        if len(fields) > 1 and fields[1] == "4":
            outfile.write(line)