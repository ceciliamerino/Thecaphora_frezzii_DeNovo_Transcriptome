# Host filtering

Reads assigned to *Arachis hypogaea* containers and reads classified as unmapped by BBSplit were remapped against the *Thecaphora frezzii* genome using BBMap.
Mapped reads were recovered as putative fungal reads, whereas unmapped reads were retained separately. SAM files were converted to FASTQ using `samtools fastq`.
Additional filtering steps were then performed to remove residual host-derived transcripts using BBMap and custom Python scripts.
