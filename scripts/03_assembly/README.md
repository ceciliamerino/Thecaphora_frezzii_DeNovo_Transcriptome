# Transcriptome assembly

Transcriptome assemblies were generated in Galaxy using:

- Trinity
- rnaSPAdes

The resulting FASTA files were downloaded and concatenated locally using the Bash cat command. The concatenated transcriptome was subsequently curated using EvidentialGene.

```bash
cat Trinity_Tfrezzii_final_C_Ga.fasta rnaSPAdes_Tfrezzii_final_C.fasta > Tfrezzii_assembly_concat_final.fasta
```

## EvidentialGene

The representative transcript set was generated with:

```bash
tr2aacds.pl \
  -cdnaseq=Tfrezzii_assembly_concat_final.fasta \
  -species=basidiomycota \
  -ablastab=blastp_table
```

This step removed redundant transcripts and selected representative sequences based on coding potential and homology evidence.
