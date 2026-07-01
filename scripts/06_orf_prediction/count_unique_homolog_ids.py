#!/usr/bin/env python3

"""
Count unique homolog identifiers stored in the fourth column of a BED file.

The fourth BED column generated during the TransDecoder workflow contains
pipe-separated annotation fields. This script extracts the homolog identifier
from the third field and reports the number of unique identifiers.

Usage:
    python count_unique_homolog_ids.py \
        --input transcriptome.transdecoder.bed
"""

import argparse


def main():
    parser = argparse.ArgumentParser(
        description="Count unique homolog identifiers in a TransDecoder BED file."
    )

    parser.add_argument(
        "-i",
        "--input",
        required=True,
        help="Input TransDecoder BED file."
    )

    args = parser.parse_args()
    unique_ids = set()

    with open(args.input, "r", encoding="utf-8") as infile:
        for line_number, line in enumerate(infile, start=1):
            if not line.strip() or line.startswith("#"):
                continue

            fields = line.rstrip("\n").split("\t")

            if len(fields) < 4:
                print(f"Skipping malformed line {line_number}: fewer than four columns.")
                continue

            annotation_fields = fields[3].split("|")

            if len(annotation_fields) < 3:
                continue

            homolog_id = annotation_fields[2].strip()

            if homolog_id:
                unique_ids.add(homolog_id)

    print(f"Unique homolog identifiers: {len(unique_ids)}")


if __name__ == "__main__":
    main()