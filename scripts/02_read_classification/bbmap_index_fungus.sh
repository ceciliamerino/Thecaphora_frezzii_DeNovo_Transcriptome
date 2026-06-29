#!/bin/bash

# Builds a BBMap index for the Thecaphora frezii reference genome.
#
# Usage:
#   bash bbmap_index_fungus.sh
#
# Edit the reference genome path before running.

REF="GCA_026284005.1_ASM2628400v1_genomic.fna"

bbmap.sh ref="$REF" usemodulo=f k=13 -Xmx48g