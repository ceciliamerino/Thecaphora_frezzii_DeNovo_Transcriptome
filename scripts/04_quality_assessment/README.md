# Transcriptome quality assessment

Assembly quality was assessed using:

- rnaQUAST v2.3.0
- BUSCO
- BBMap stats.sh

## rnaQUAST

rnaQUAST was executed locally with:

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

## BUSCO

BUSCO analyses were also performed independently using the Galaxy Australia server to evaluate transcriptome completeness (including SuperTranscripts assemblies).
