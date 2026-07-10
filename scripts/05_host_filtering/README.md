# Host filtering

This directory contains scripts used to remove transcript sequences showing similarity to the peanut host genome.

## Overview

The curated de novo *Thecaphora frezzii* transcriptome was independently aligned against four *Arachis hypogaea* reference genome assemblies using BBMap.

The peanut reference genomes used in this step are listed in:

```text
../../resources/reference_genomes.md
```

For each peanut genome alignment, transcripts that did not map to the corresponding peanut reference were retained. In the SAM output, these unmapped records were identified by `FLAG = 4`.

For each alignment:

1. SAM records with `FLAG = 4` were retained.
2. Transcript identifiers were extracted from the filtered SAM file.
3. The corresponding transcript sequences were recovered from the original FASTA file.

This procedure was repeated independently for each peanut reference genome.

After this initial host-filtering step, additional refinement was performed to reduce residual host-derived sequences by comparing the filtered transcript sets across peanut reference genomes. This refinement step is described in the manuscript. Large intermediate files and custom comparison outputs are not included in this repository.

## Scripts

- `filter_flag4.py`  
  Retains only SAM records with `FLAG = 4`, corresponding to transcripts that did not map to the peanut reference genome.

- `extract_names.py`  
  Extracts transcript identifiers from the filtered SAM file.

- `filter_fasta_by_ids.py`  
  Recovers FASTA sequences whose identifiers are present in the retained transcript ID list.

## Notes

This directory documents the host-filtering strategy applied after transcriptome assembly and curation. The goal of this step was to retain transcript sequences with no detectable alignment to the peanut host reference genomes.

Large SAM files, filtered FASTA files and intermediate host-filtering outputs are not included in this repository.
