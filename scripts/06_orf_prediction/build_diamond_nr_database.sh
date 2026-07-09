#!/usr/bin/env bash

set -euo pipefail

# Download the NCBI nr protein database and taxonomy files,
# and build a DIAMOND database containing taxonomic information.
#
# Usage:
#   bash build_diamond_nr_database.sh

for program in wget gunzip unzip diamond; do
    if ! command -v "$program" >/dev/null 2>&1; then
        echo "Error: required program not found: $program"
        exit 1
    fi
done

echo
echo "Step 1: Downloading and decompressing the NCBI nr protein database..."
wget -qO- ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz | gunzip > nr

echo
echo "Step 2: Downloading NCBI taxonomy files..."
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip

echo
echo "Step 3: Decompressing taxonomy files..."
gunzip prot.accession2taxid.gz
unzip taxdmp.zip

echo
echo "Step 4: Building the DIAMOND nr database..."
diamond makedb \
    --in nr \
    --taxonmap prot.accession2taxid \
    --taxonnodes nodes.dmp \
    --taxonnames names.dmp \
    --db nr

if [[ ! -f "nr.dmnd" ]]; then
    echo "Error: DIAMOND database was not created."
    exit 1
fi

echo
echo "DIAMOND database successfully created:"
ls -lh nr.dmnd