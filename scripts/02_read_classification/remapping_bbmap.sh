#!/usr/bin/env bash

# Remaps transcript reads against the Thecaphora frezzii reference genome
# using BBMap to separate mapped and unmapped reads.
#
# Reference genome:
#   GCA_026284005.1_ASM2628400v1
#
# Usage:
#   bash remapping_bbmap.sh
#
# Edit the input and output directories before running.

# Modify these paths according to your local installation.
input_dir="/path/to/reference_genome"
output_dir="/path/to/output_directory"

# Archivo específico en el directorio de entrada
input_file_r1="${input_dir}GCA_026284005.1_ASM2628400v1_genomic.fna"

# Verificar la existencia del archivo de entrada
if [ ! -f "$input_file_r1" ]; then
    echo "El archivo de entrada no existe: ${input_file_r1}"
    exit 1
fi

echo "Procesando archivo: $input_file_r1"

# Obtener el nombre base del archivo sin la extensión
base_name=$(basename "$input_file_r1" .fna)

# Construir el nombre del archivo de salida
output_file_r1="${output_dir}${base_name}_Tfrezzii"

# Ejecución de BBmap
bbmap.sh -Xmx40g \
    in1=concat_B_F_S_T_U_Tfrezzii_1.fq.gz \
    in2=concat_B_F_S_T_U_Tfrezzii_2.fq.gz \
    ref="$input_file_r1" \
    outm="${output_file_r1}.mapped.sam" \
    outu="${output_file_r1}.unmapped.sam" \
    maxindel=200 \
    minid=0.9

# Convertir SAM a FASTQ de pares
samtools fastq "${output_file_r1}.mapped.sam" -1 "${output_file_r1}_mapped_1.fq" -2 "${output_file_r1}_mapped_2.fq" -0 /dev/null -s /dev/null -n

# Convertir SAM a FASTQ de pares para el archivo unmapped
samtools fastq "${output_file_r1}.unmapped.sam" -1 "${output_file_r1}_unmapped_1.fq" -2 "${output_file_r1}_unmapped_2.fq" -0 /dev/null -s /dev/null -n

# Opcional: eliminar el archivo SAM para ahorrar espacio
# rm "${output_file_r1}.mapped.sam"

