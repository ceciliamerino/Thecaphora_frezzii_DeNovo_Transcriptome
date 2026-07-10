#!/usr/bin/env bash

# Repair paired-end reads after preprocessing.
#
# Original usage:
#   cat CleanCumplifyFile.txt | xargs -n 1 bash repair_reads.sh
#
# Input:
#   One R1 FASTQ filename provided as the first argument.
#   The corresponding R2 filename is inferred by replacing 1.fastq.gz with 2.fastq.gz.

echo
echo "Processing $1"
echo

DIR=/media/danilo/Tera2/Analysis/CeciMerino/Analysis_pipeline/00_Fastp

R1=$1
R2=${R1/1.fastq.gz/2.fastq.gz}
name=${R1/_1.fastq.gz/}

echo
echo "R1: $R1"
echo "R2: $R2"
echo

repair.sh \
    in1=$DIR/$R1 \
    in2=$DIR/$R2 \
    out1=repair_$R1 \
    out2=repair_$R2 \
    outs=single_$name.fq \
    -Xmx48g \
    ziplevel=5
