# Step 1. Reference-based read classification (BBSplit)

RNA-seq reads were classified against four *Arachis hypogaea* reference genomes and the *Thecaphora frezzii* reference genome using BBSplit. Reads assigned to the peanut reference genomes were discarded, whereas reads assigned to the fungal reference genome and reads remaining unclassified (unmapped) were retained for downstream analyses.

# Step 2. Reference-guided fungal read recovery (BBMap)

Reads assigned to the peanut containers and reads remaining unmapped after BBSplit were independently remapped against the *Thecaphora frezzii* reference genome using BBMap to recover reads matching the available fungal reference genome.
