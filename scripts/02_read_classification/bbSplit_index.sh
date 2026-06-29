#!/bin/bash

# Builds the BBSplit reference database used for host-pathogen read classification.
#
# Reference genome assemblies are listed in:
# ../../resources/reference_genomes.md
#
# Edit the paths to the reference FASTA files before running.

REF_FUHUASHENG="/path/to/Fuhuasheng_reference.fna"
REF_SHITOUQI="/path/to/Shitouqi_reference.fna"
REF_TIFRUNNER="/path/to/Tifrunner_reference.fna"
REF_BAILEY="/path/to/BaileyII_reference.fna"
REF_TFREZII="/path/to/Tfrezii_reference.fna"

bbsplit.sh \
  build=1 \
  ref_fuhuasheng="$REF_FUHUASHENG" \
  ref_shitouqi="$REF_SHITOUQI" \
  ref_tifrunner="$REF_TIFRUNNER" \
  ref_bailey="$REF_BAILEY" \
  ref_tfrezii="$REF_TFREZII" \
  -Xmx48g