#!/bin/bash

# Classifies paired-end RNA-seq reads using BBSplit against host and pathogen reference genomes.
# The BBSplit reference database is described in:
# ../../resources/reference_genomes.md
#
# Usage:
#   cat sample_list.txt | xargs -n 1 bash bbsplit_classification.sh

# Activate the appropriate conda environment if needed
# conda activate bioinfo

# Directory containing the BBSplit reference database
REF="/path/to/bbsplit_reference_database"

# Directory containing repaired paired-end FASTQ files
DIR="/path/to/repaired_fastq_files"

# Output directory
OUTDIR="./bbsplit_output"

# Statistics directory
STAT="./stats"

mkdir -p "$OUTDIR"
mkdir -p "$STAT"

R1=$1
R2=${R1/1.fastq.gz/2.fastq.gz}

name=${R1/_1.fastq.gz/}
name=${name/repair_clean_clumpify_/}

echo
echo "############################################"
echo "Processing sample: $name"
echo "Reference database: $REF"
echo "R1: $DIR/$R1"
echo "R2: $DIR/$R2"
echo "Output directory: $OUTDIR"
echo "############################################"
echo

if [ -f "$OUTDIR/$name.ok" ]; then
    echo "Sample $name already processed. Skipping."
else
    bbsplit.sh \
        -Xmx48g \
        pigz=t \
        threads=6 \
        path="$REF" \
        build=1 \
        in="$DIR/$R1" \
        in2="$DIR/$R2" \
        basename="$OUTDIR/o.${name}_%_#.fq" \
        outu1="$OUTDIR/unmapped_${name}_1.fq" \
        outu2="$OUTDIR/unmapped_${name}_2.fq" \
        bstats="$STAT/${name}.bstats.txt"

    touch "$OUTDIR/$name.ok"
fi

pigz -6 "$OUTDIR"/*.fq