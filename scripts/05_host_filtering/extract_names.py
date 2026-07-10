#!/usr/bin/env python3

"""
Extract transcript IDs from the first column of a SAM file.

This script reads a SAM file previously filtered by SAM FLAG = 4
and writes the transcript identifiers from the first column to a
plain text file, one ID per line.

Usage:
    python extract_names.py \
        --input_file filtered_flag4.sam \
        --output_file transcript_ids.txt
"""

import argparse


def main():
    parser = argparse.ArgumentParser(
        description="Extract transcript IDs from the first column of a SAM file."
    )

    parser.add_argument(
        "-i",
        "--input_file",
        required=True,
        help="Input SAM file filtered by SAM FLAG = 4."
    )

    parser.add_argument(
        "-o",
        "--output_file",
        required=True,
        help="Output text file containing transcript IDs."
    )

    args = parser.parse_args()

    with open(args.input_file, "r") as infile, open(args.output_file, "w") as outfile:
        for line in infile:
            if line.startswith("@"):
                continue

            fields = line.rstrip("\n").split("\t")

            if len(fields) > 0:
                outfile.write(fields[0] + "\n")


if __name__ == "__main__":
    main()