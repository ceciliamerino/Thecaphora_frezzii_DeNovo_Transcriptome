# Transcriptome assembly

Transcriptome assemblies were generated using Galaxy.

## Assembly software

- Trinity
- rnaSPAdes

The resulting transcriptome assemblies were downloaded from Galaxy and subsequently merged and curated locally using EvidentialGene.

## Local scripts

- `merge_evidentialgene.sh`
  Merges Trinity and rnaSPAdes assemblies and removes redundant transcripts using EvidentialGene.
