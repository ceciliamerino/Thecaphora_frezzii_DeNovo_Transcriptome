#!/usr/bin/env python3

"""
Filter a FASTA file using a list of sequence IDs.

This script reads a FASTA file and a text file containing sequence IDs,
and writes to the output FASTA only the sequences whose IDs are present
in the ID list.

In this pipeline, the ID list is generated from SAM records with
SAM FLAG = 4, corresponding to transcripts that did not map to the
peanut reference genome.

Usage:
    python filter_fasta_by_ids.py \
        --input transcriptome.fasta \
        --ids transcript_ids.txt \
        --output filtered_transcriptome.fasta
"""

import argparse


def filter_fasta_by_ids(fasta_file, ids_file, output_file):
    with open(ids_file, "r") as handle:
        keep_ids = set(line.strip() for line in handle if line.strip())

    write_sequence = False
    current_sequence = []

    with open(fasta_file, "r") as fasta_in, open(output_file, "w") as fasta_out:
        for line in fasta_in:
            if line.startswith(">"):
                if current_sequence and write_sequence:
                    fasta_out.write("".join(current_sequence))

                current_sequence = []
                sequence_id = line[1:].split()[0]
                write_sequence = sequence_id in keep_ids

            current_sequence.append(line)

        if current_sequence and write_sequence:
            fasta_out.write("".join(current_sequence))


def main():
    parser = argparse.ArgumentParser(
        description="Filter a FASTA file by retaining sequences whose IDs are listed in a text file."
    )

    parser.add_argument(
        "-i",
        "--input",
        required=True,
        help="Input FASTA file."
    )

    parser.add_argument(
        "--ids",
        required=True,
        help="Text file containing sequence IDs to retain, one per line."
    )

    parser.add_argument(
        "-o",
        "--output",
        required=True,
        help="Output filtered FASTA file."
    )

    args = parser.parse_args()

    filter_fasta_by_ids(args.input, args.ids, args.output)


if __name__ == "__main__":
    main()