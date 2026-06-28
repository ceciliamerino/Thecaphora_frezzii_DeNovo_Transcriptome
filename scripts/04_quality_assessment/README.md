# Transcriptome quality assessment

Assembly quality was assessed using:

- rnaQUAST v2.3.0
- BUSCO v5.7.1
- BBMap stats.sh

## rnaQUAST

rnaQUAST was executed with the following command:

```bash
rnaQUAST.py \
  --threads 12 \
  --transcripts Trinity_Tfrezii_final_C_Ga.fasta \
                 rnaSPAdes_Tfrezii_final_C.fasta \
                 transcriptoma_filtrado_TF_segunda_iteracion \
  --left_reads concat_Tfrezii_final_C_1.fq.gz \
  --right_reads concat_Tfrezii_final_C_2.fq.gz \
  --min_alignment 50 \
  --busco basidiomycota_odb10 \
  --lower_threshold 50 \
  --upper_threshold 95 \
  --strand_specific \
  -o outputdir
```

BUSCO completeness and assembly statistics obtained with rnaQUAST were used to compare the different transcriptome assemblies.
