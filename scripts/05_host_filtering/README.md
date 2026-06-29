# Host filtering

This directory contains the scripts used to remove transcript sequences showing similarity to the peanut host genome.

## Overview

The de novo assembled *Thecaphora frezii* transcriptome was independently aligned against four *Arachis hypogaea* reference genome assemblies using BBMap. The reference genome assemblies are listed in ../../resources/reference_genomes.md.

For each alignment:

1. SAM records with FLAG = 4 (transcripts that did not map to the peanut genome) were retained.
2. Transcript IDs were extracted from the filtered SAM file.
3. The corresponding transcript sequences were recovered from the original FASTA file.

This procedure was repeated independently for each peanut reference genome assembly.

## Scripts

- `filter_flag4.py`  
  Retains only SAM records with FLAG = 4 (unmapped transcripts).

- `extract_names.py`  
  Extracts transcript IDs from the filtered SAM file.

- `filter_fasta_by_ids.py`  
  Recovers transcript sequences whose IDs are listed in the input ID file.


