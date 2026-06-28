# Read classification

This directory contains the scripts used to classify RNA-seq reads with BBSplit.

The BBSplit reference database was built using four *Arachis hypogaea* genome assemblies and the *Thecaphora frezzii* genome (see `../../resources/reference_genomes.md`).

## Scripts

- `bbsplit_classification.sh`  
  Classifies paired-end RNA-seq reads into host-derived reads, *T. frezzii* reads, and unmapped reads using BBSplit.
