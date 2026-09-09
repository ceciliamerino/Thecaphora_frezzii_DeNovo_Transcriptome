# Read classification

This directory contains the scripts used for reference-based classification and recovery of RNA-seq reads.

## Step 1. Reference-based read classification (BBSplit)

RNA-seq reads were classified against four *Arachis hypogaea* reference genomes and the *Thecaphora frezzii* reference genome using BBSplit.

The BBSplit reference database was built using the genome assemblies listed in `../../resources/reference_genomes.md`.

## Step 2. Reference-guided fungal read recovery (BBMap)
Reads assigned to the *Arachis hypogaea* output containers and reads remaining unmapped after BBSplit were remapped against the available *Thecaphora frezzii* reference genome using BBMap. Reads mapping to the fungal reference genome were retained for downstream analyses.

The fungal reads recovered by BBMap were concatenated with the reads initially assigned to *T. frezzii* by BBSplit using the Bash `cat` command to generate the final paired-end read dataset used for transcriptome assembly:

```bash
cat <initial_Tfrezii_R1.fastq.gz> <recovered_mapped_R1.fastq.gz> > concat_Tfrezii_final_C_1.fq.gz
cat <initial_Tfrezii_R2.fastq.gz> <recovered_mapped_R2.fastq.gz> > concat_Tfrezii_final_C_2.fq.gz
```

## Scripts

- `bbsplit_index.sh`  
  Builds the BBSplit reference database from the reference genomes listed in ../../resources/reference_genomes.md.

- `bbsplit_classification.sh`  
  Classifies paired-end RNA-seq reads into host-derived reads, *T. frezzii* reads, and unmapped reads using BBSplit.

- `bbmap_index_fungus.sh`
  Builds the BBMap index for the *Thecaphora frezzii* reference genome.

- `remapping_bbmap.sh`  
  Remaps reads from the Arachis hypogaea containers and reads remaining unmapped after BBSplit to the *T. frezzii* reference genome using BBMap.

