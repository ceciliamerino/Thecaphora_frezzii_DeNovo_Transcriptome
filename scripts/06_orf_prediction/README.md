# ORF prediction

This directory contains the scripts used to predict protein-coding regions from the final host-filtered *Thecaphora frezii* transcriptome.

## Overview

Candidate open reading frames were first identified using `TransDecoder.LongOrfs`. The resulting predicted protein sequences were searched against the NCBI non-redundant protein database using DIAMOND BLASTp.

Protein homology results were subsequently incorporated into `TransDecoder.Predict` using the `--retain_blastp_hits` option. The `--single_best_only` option was used to retain a single best-supported ORF per transcript.

The workflow produced the following principal output files:

* predicted protein sequences (`.transdecoder.pep`);
* predicted coding sequences (`.transdecoder.cds`);
* predicted ORF coordinates (`.transdecoder.gff3`);
* BED-formatted ORF coordinates and annotations (`.transdecoder.bed`).

## Workflow

1. Candidate long ORFs were identified with `TransDecoder.LongOrfs`.
2. Candidate protein sequences were searched against the NCBI nr protein database using DIAMOND BLASTp.
3. Homology-supported ORFs were selected with `TransDecoder.Predict`.
4. A single best ORF was retained per transcript.

## Scripts

* `transdecoder_orf_prediction.sh`
  Runs the complete ORF prediction workflow: `TransDecoder.LongOrfs`, DIAMOND BLASTp and `TransDecoder.Predict`.

* `count_unique_homolog_ids.py`
  Extracts and counts unique homolog identifiers encoded in the annotation field of the TransDecoder BED output.
