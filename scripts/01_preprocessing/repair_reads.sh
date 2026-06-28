#!/bin/bash

# Activate the appropriate conda environment if needed
# conda activate bioinfo

# Repairs paired-end FASTQ files using BBTools Repair.

# Usage:
# cat sample_list.txt | xargs -n 1 bash repair_reads.sh

echo
echo "Processing $1"
echo 

# Set the directory containing the FASTQ files
DIR="/path/to/fastq/files"

R1=$1
R2=${R1/1.fastq.gz/2.fastq.gz}
name=${R1/_1.fastq.gz}

echo
echo "R1: $R1"
echo "R2: $R2"
echo

if [ -f "./reports/$html.html" ]; then
	echo "Sample $R1 already processed. Skipping."
else
	repair.sh in1=$DIR/$R1 -in2=$DIR/$R2 out1=repair_$R1 -out2=repair_$R2 \
	outs=single_$name.fq -Xmx48g ziplevel=5
fi

