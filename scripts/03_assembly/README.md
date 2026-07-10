# Transcriptome assembly

Transcriptome assemblies were generated in Galaxy using:

- Trinity
- rnaSPAdes

The resulting FASTA files were downloaded and merged locally using EvidentialGene.

## EvidentialGene

The representative transcript set was generated with:

```bash
tr2aacds.pl \
  -cdnaseq=Tfrezzii_assembly_concat_final.fasta \
  -species=basidiomycota \
  -ablastab=blastp_table
```

This step removed redundant transcripts and selected representative sequences based on coding potential and homology evidence.
