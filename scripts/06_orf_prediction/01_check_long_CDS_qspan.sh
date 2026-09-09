#!/usr/bin/env bash
set -euo pipefail

# ========= CONFIG =========
CDS="transcriptoma_filtrado_TF_segunda_iteracion.transdecoder.cds"
PEP_RAW="transcriptoma_filtrado_TF_segunda_iteracion.transdecoder.pep"
PEP_CLEAN="pep_clean.faa"

SPROT_FASTA="uniprot_sprot.fasta"
SPROT_DB="uniprot_sprot.dmnd"

LEN_THR=5000
EVAL_CUTOFF="1e-10"
COV_CUTOFF="0.7"
PID_CUTOFF="30"

# ========= CHEQUEOS =========
command -v seqkit >/dev/null 2>&1 || { echo "ERROR: seqkit no está en PATH"; exit 1; }
command -v diamond >/dev/null 2>&1 || { echo "ERROR: diamond no está en PATH"; exit 1; }
command -v gawk   >/dev/null 2>&1 || { echo "ERROR: gawk no está en PATH"; exit 1; }

[[ -s "$CDS" ]] || { echo "ERROR: no encuentro $CDS"; exit 1; }
[[ -s "$PEP_RAW" ]] || { echo "ERROR: no encuentro $PEP_RAW"; exit 1; }
[[ -s "$SPROT_DB" ]] || { echo "ERROR: no encuentro $SPROT_DB"; exit 1; }

echo "=== CHECK long CDS (>=${LEN_THR} nt) | $(diamond --version | head -1) ==="

# ========= 0) Normalizar headers del .pep =========
if [[ ! -s "$PEP_CLEAN" ]]; then
  echo "→ Generando $PEP_CLEAN (normalización de headers: primer token)…"
  seqkit replace -p ' .*' -r '' "$PEP_RAW" > "$PEP_CLEAN"
else
  echo "→ $PEP_CLEAN ya existe (se reutiliza)."
fi

# ========= 1) IDs de CDS largos (>= LEN_THR) =========
echo "→ Extrayendo IDs de CDS >= ${LEN_THR} nt…"
# En tu seqkit: fx2tab -n -l => col2 = length
seqkit fx2tab -n -l "$CDS" \
| gawk -v T="$LEN_THR" 'BEGIN{FS=OFS="\t"}{id=$1; sub(/ .*/,"",id); if($2>=T) print id}' \
| sort -u > long_ids_presentes.ids

N_LONG=$(wc -l < long_ids_presentes.ids || echo 0)
[[ "$N_LONG" -gt 0 ]] || { echo "ERROR: long_ids_presentes.ids vacío"; exit 1; }
echo "→ Long CDS: $N_LONG"

# ========= 2) Extraer proteínas correspondientes =========
echo "→ Extrayendo proteínas largas (long.pep.faa)…"
seqkit grep -n -f long_ids_presentes.ids "$PEP_CLEAN" > long.pep.faa
N_PEP=$(grep -c '^>' long.pep.faa || echo 0)
[[ "$N_PEP" -gt 0 ]] || { echo "ERROR: long.pep.faa vacío"; exit 1; }
echo "→ long.pep.faa: $N_PEP secuencias"

# ========= 3) DIAMOND blastp vs Swiss-Prot (qstart/qend) =========
echo "→ DIAMOND blastp vs Swiss-Prot…"
diamond blastp \
  -q long.pep.faa \
  -d "$SPROT_DB" \
  -e "$EVAL_CUTOFF" \
  --max-target-seqs 5 \
  --outfmt 6 qseqid sseqid pident length qstart qend qlen evalue bitscore stitle \
  -o long_vs_sprot_qspan.tsv

# ========= 4) Calcular qcov real + PASS/CHECK =========
echo "→ Calculando qcov=(|qend-qstart|+1)/qlen y clasificando…"
gawk -v EC="$EVAL_CUTOFF" -v CC="$COV_CUTOFF" -v PC="$PID_CUTOFF" 'BEGIN{OFS="\t"}
{
  span = ($6>$5 ? $6-$5 : $5-$6) + 1
  cov  = span / $7
  flag = ($8<=EC && cov>=CC && $3>=PC) ? "PASS" : "CHECK"

  stitle=""
  for(i=10;i<=NF;i++) stitle = stitle (i==10 ? "" : " ") $i

  # qseqid pident aln_len qstart qend qlen qcov evalue bitscore flag stitle
  print $1,$3,$4,$5,$6,$7,cov,$8,$9,flag,stitle
}' long_vs_sprot_qspan.tsv > long_eval_qspan.tsv

# ========= 5) Mejor hit por query =========
echo "→ Seleccionando mejor hit por query (máx bitscore)…"
LC_NUMERIC=C sort -k1,1 -k9,9nr long_eval_qspan.tsv | gawk '!seen[$1]++' > long_besthit_qspan.tsv

# ========= 6) NO_HIT =========
echo "→ Calculando NO_HIT…"
cut -f1 long_besthit_qspan.tsv | sort -u > have_hit.ids
comm -23 <(sort -u long_ids_presentes.ids) <(sort -u have_hit.ids) > NO_HIT.ids

# ========= 7) Resumen =========
PASS=$(gawk '$10=="PASS"{c++} END{print c+0}' long_besthit_qspan.tsv)
CHECK=$(gawk '$10=="CHECK"{c++} END{print c+0}' long_besthit_qspan.tsv)
NOHIT=$(wc -l < NO_HIT.ids)

echo "→ Resumen (besthit): PASS=$PASS CHECK=$CHECK NO_HIT=$NOHIT TOTAL=$((PASS+CHECK+NOHIT))"
echo "→ Control qcov>1 (debe ser 0): $(gawk '{if($7>1)bad++} END{print bad+0}' long_besthit_qspan.tsv)"

echo "Archivos clave generados:"
echo " - $PEP_CLEAN"
echo " - long.pep.faa"
echo " - long_vs_sprot_qspan.tsv"
echo " - long_eval_qspan.tsv"
echo " - long_besthit_qspan.tsv"
echo " - NO_HIT.ids"
echo "=== DONE ==="
