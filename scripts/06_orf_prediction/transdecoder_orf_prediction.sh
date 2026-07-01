bash
#!/usr/bin/env bash

set -euo pipefail

# Predict open reading frames using TransDecoder and DIAMOND BLASTp evidence.
#
# Workflow:
#   1. Identify candidate long ORFs with TransDecoder.LongOrfs.
#   2. Search predicted proteins against the NCBI nr DIAMOND database.
#   3. Perform final ORF prediction with TransDecoder.Predict,
#      retaining ORFs supported by protein homology and selecting
#      a single best ORF per transcript.
#
# Usage:
#   bash transdecoder_orf_prediction.sh \
#       final_filtered_transcriptome.fasta \
#       /path/to/nr.dmnd \
#       10

TRANSCRIPTOME="${1:-}"
DIAMOND_DB="${2:-}"
THREADS="${3:-10}"

if [[ -z "$TRANSCRIPTOME" || -z "$DIAMOND_DB" ]]; then
    echo "Usage:"
    echo "  bash transdecoder_orf_prediction.sh <transcriptome.fasta> <nr.dmnd> [threads]"
    exit 1
fi

if [[ ! -f "$TRANSCRIPTOME" ]]; then
    echo "Error: transcriptome file not found: $TRANSCRIPTOME"
    exit 1
fi

if [[ ! -f "$DIAMOND_DB" ]]; then
    echo "Error: DIAMOND database not found: $DIAMOND_DB"
    exit 1
fi

for program in TransDecoder.LongOrfs TransDecoder.Predict diamond; do
    if ! command -v "$program" >/dev/null 2>&1; then
        echo "Error: required program not found: $program"
        exit 1
    fi
done

PREFIX=$(basename "$TRANSCRIPTOME")
PREFIX="${PREFIX%.*}"

TRANSDECODER_DIR="${TRANSCRIPTOME}.transdecoder_dir"
LONGEST_ORFS="${TRANSDECODER_DIR}/longest_orfs.pep"
BLASTP_OUTPUT="${PREFIX}.diamond_blastp.outfmt6"

echo
echo "Step 1: Identifying candidate long ORFs..."
TransDecoder.LongOrfs \
    -t "$TRANSCRIPTOME"

if [[ ! -f "$LONGEST_ORFS" ]]; then
    echo "Error: TransDecoder.LongOrfs output not found: $LONGEST_ORFS"
    exit 1
fi

echo
echo "Step 2: Searching candidate proteins against the NCBI nr database..."
diamond blastp \
    --query "$LONGEST_ORFS" \
    --db "$DIAMOND_DB" \
    --max-target-seqs 1 \
    --out "$BLASTP_OUTPUT" \
    --outfmt 6 \
    --threads "$THREADS"

echo
echo "Step 3: Performing final ORF prediction..."
TransDecoder.Predict \
    -t "$TRANSCRIPTOME" \
    --retain_blastp_hits "$BLASTP_OUTPUT" \
    --single_best_only

echo
echo "ORF prediction completed."
echo "Main output files:"
echo "  ${TRANSCRIPTOME}.transdecoder.pep"
echo "  ${TRANSCRIPTOME}.transdecoder.cds"
echo "  ${TRANSCRIPTOME}.transdecoder.gff3"
echo "  ${TRANSCRIPTOME}.transdecoder.bed"

