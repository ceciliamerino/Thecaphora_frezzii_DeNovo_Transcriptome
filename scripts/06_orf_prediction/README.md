# ORF prediction

This directory contains the scripts used to predict, curate and validate protein-coding regions from the final host-filtered *Thecaphora frezii* transcriptome.

## Overview

Open reading frames (ORFs) were predicted using TransDecoder. Candidate coding regions were first identified with `TransDecoder.LongOrfs`.

Protein homology evidence was obtained through DIAMOND BLASTp searches against the NCBI non-redundant protein database. For this purpose, the NCBI nr database was downloaded and converted into a DIAMOND database (`nr.dmnd`) including taxonomic information.

DIAMOND BLASTp results were subsequently incorporated into `TransDecoder.Predict` using the `--retain_blastp_hits` option. The `--single_best_only` option was used to retain a single best-supported ORF per transcript.

After ORF prediction, custom post-processing was used to retain non-redundant coding sequences by selecting isoforms encoding unique CDSs and prioritizing the longest representative sequence.

Predicted CDSs longer than 5,000 nt were additionally inspected through DIAMOND BLASTp searches against the Swiss-Prot database to assess potential assembly artifacts.

The workflow produced the following principal output files:

- predicted protein sequences (`.transdecoder.pep`);
- predicted coding sequences (`.transdecoder.cds`);
- predicted ORF coordinates (`.transdecoder.gff3`);
- BED-formatted ORF coordinates and annotations (`.transdecoder.bed`).

## Workflow

1. The NCBI nr protein database was downloaded and converted into a DIAMOND database.
2. Candidate long ORFs were identified with `TransDecoder.LongOrfs`.
3. Candidate protein sequences were searched against the NCBI nr protein database using DIAMOND BLASTp, retaining one best target sequence per query.
4. Homology-supported ORFs were selected with `TransDecoder.Predict`.
5. A single best ORF was retained per transcript using `--single_best_only`.
6. Non-redundant CDSs were curated by selecting unique CDS isoforms and prioritizing the longest representative sequence.
7. CDSs longer than 5,000 nt were further checked against Swiss-Prot to assess potential assembly artifacts.

## Scripts

- `build_diamond_nr_database.sh`  
  Downloads the NCBI nr protein database and taxonomy files, and builds the DIAMOND database used for protein homology searches.

- `transdecoder_orf_prediction.sh`  
  Runs the ORF prediction workflow: `TransDecoder.LongOrfs`, DIAMOND BLASTp against nr, and `TransDecoder.Predict`.

- `count_unique_homolog_ids.py`  
  Extracts and counts unique homolog identifiers encoded in the annotation field of the TransDecoder BED output.

## Notes

Large database files and analysis outputs are not included in this repository. This includes `nr`, `nr.dmnd`, taxonomy files, DIAMOND output tables and TransDecoder output files.
