# Archivo de entrada con las secuencias, incluyendo encabezados
input_file_cds_filtrado = "transcriptoma_filtrado_TF_segunda_iteracion.transdecoder.cds"  

# Archivo de salida con las secuencias filtradas y sus encabezados
output_file = "transcriptoma_filtrado_TF_unico.transdecoder.cds"  

# Diccionario para almacenar las secuencias
secuencias = {}
encabezado_actual = None
secuencia_actual = ""

try:
    with open(input_file_cds_filtrado, "r") as input, open(output_file, "w") as output:
        for line in input:
            line = line.strip()  # Eliminar saltos de línea y espacios extra

            if line.startswith(">"):  # Encabezado de secuencia
                # Si ya se ha leído una secuencia completa, almacenarla
                if encabezado_actual:
                    # Guardar solo las secuencias únicas
                    if secuencia_actual not in secuencias:
                        secuencias[secuencia_actual] = encabezado_actual
                
                encabezado_actual = line  # Actualizar encabezado
                secuencia_actual = ""  # Resetear la secuencia

            else:  # Parte de la secuencia
                secuencia_actual += line  # Añadir a la secuencia

        # Al final del archivo, añadir la última secuencia leída
        if secuencia_actual and secuencia_actual not in secuencias:
            secuencias[secuencia_actual] = encabezado_actual
        
        # Escribir en el archivo de salida solo las secuencias únicas
        for secuencia in secuencias:
            output.write(secuencias[secuencia] + "\n")
            output.write(secuencia + "\n")

    print(f"Se han filtrado las secuencias duplicadas y se han guardado en {output_file}.")

except FileNotFoundError:
    print(f"El archivo {input_file_cds_filtrado} no se encontró.")
except Exception as e:
    print(f"Error durante la ejecución: {e}")


