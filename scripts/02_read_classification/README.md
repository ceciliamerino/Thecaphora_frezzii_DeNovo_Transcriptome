# Read classification

This directory contains the scripts used for reference-based classification and recovery of RNA-seq reads.

## Step 1. Reference-based read classification (BBSplit)

RNA-seq reads were classified against four *Arachis hypogaea* reference genomes and the *Thecaphora frezzii* reference genome using BBSplit.

The BBSplit reference database was built using the genome assemblies listed in `../../resources/reference_genomes.md`.

## Step 2. Reference-guided fungal read recovery (BBMap)

Reads assigned to the *Arachis hypogaea* containers and reads remaining unmapped after BBSplit were remapped against the available *Thecaphora frezzii* reference genome using BBMap to recover reads matching the fungal genome.

## Scripts

- `bbsplit_index.sh`  
  Builds the BBSplit reference database from the reference genomes listed in ../../resources/reference_genomes.md.

- `bbsplit_classification.sh`  
  Classifies paired-end RNA-seq reads into host-derived reads, *T. frezzii* reads, and unmapped reads using BBSplit.

- `bbmap_index_fungus.sh` 
  Builds the BBMap index for the Thecaphora frezii reference genome.

- `remapping_bbmap.sh`  
  Remaps reads from the *Arachis hypogaea* containers and unmapped reads against the *T. frezzii* reference genome using BBMap.




• remapping_bbmap.sh
  Remaps reads from the Arachis hypogaea containers and unmapped reads against the T. frezii reference genome using BBMap.
