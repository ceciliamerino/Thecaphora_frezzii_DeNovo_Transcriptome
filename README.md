# De Novo Transcriptome Assembly Pipeline for *Thecaphora frezzii*

This repository contains the bioinformatics pipeline used to reconstruct and curate a high-quality de novo transcriptome of the peanut smut fungus *Thecaphora frezzii* from RNA-seq data.

The pipeline includes RNA-seq preprocessing, host-pathogen read classification, fungal read recovery, de novo transcriptome assembly, transcriptome quality assessment, transcriptome curation, host transcript filtering, ORF prediction, and protein homology searches.

## Workflow

![Pipeline](docs/pipeline.png)

## Repository structure

```text
docs/
    Pipeline figures

scripts/
    Custom Bash and Python scripts

config/
    Configuration files

resources/
    Reference genomes and annotation databases

results/
    Example outputs
```

## Software

The workflow was implemented using:

- BBTools v39.01
- fastp v0.23.2
- Trinity v2.15.1
- rnaSPAdes v3.15.5
- EvidentialGene v2022.04.05
- Subread v2.0.6
- rnaQUAST v2.3.0
- BUSCO v5.5.0 and v5.7.1
- TransDecoder v5.7.1
- DIAMOND v2.1.10 and v2.1.23
- samtools
- Python and standard Unix command-line utilities including wget, gunzip, unzip and pigz.
  
## Citation

Manuscript under review.

## Contact

María Cecilia Merino  
INIMEC-CONICET–UNC, Córdoba, Argentina  
Email: cmerino@immf.uncor.edu
