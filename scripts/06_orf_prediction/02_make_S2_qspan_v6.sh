#!/usr/bin/env bash
set -euo pipefail

CDS="transcriptoma_filtrado_TF_segunda_iteracion.transdecoder.cds"
PEP="pep_clean.faa"
BESTHIT="long_besthit_qspan.tsv"
NOHIT="NO_HIT.ids"
OUT="Supplementary_Table_S2.tsv"

command -v seqkit >/dev/null 2>&1 || { echo "ERROR: seqkit no está en PATH"; exit 1; }
command -v gawk   >/dev/null 2>&1 || { echo "ERROR: gawk no está en PATH"; exit 1; }

[[ -s "$CDS" ]] || { echo "ERROR: no encuentro $CDS"; exit 1; }
[[ -s "$PEP" ]] || { echo "ERROR: no encuentro $PEP"; exit 1; }
[[ -s "$BESTHIT" ]] || { echo "ERROR: no encuentro $BESTHIT"; exit 1; }

# cds_len.tsv: ID (primer token del header) + LENGTH (col 2)
seqkit fx2tab -n -l "$CDS" \
| gawk 'BEGIN{FS=OFS="\t"}{id=$1; sub(/ .*/,"",id); print id,$2}' \
> cds_len.tsv

# pep_len.tsv: ID + LENGTH (col 2)
seqkit fx2tab -n -l "$PEP" \
| gawk 'BEGIN{FS=OFS="\t"}{id=$1; sub(/ .*/,"",id); print id,$2}' \
> pep_len.tsv

# Header correcto (TAB entre bitscore y classification)
echo -e "qseqid\tcds_len_nt\tpep_len_aa\tpident\taln_len\tqstart\tqend\tqlen\tqcov\tevalue\tbitscore\tclassification\tstitle" > "$OUT"

# PASS/CHECK
gawk 'BEGIN{FS=OFS="\t"}
  FILENAME==ARGV[1] {cds[$1]=$2; next}
  FILENAME==ARGV[2] {pep[$1]=$2; next}
  FILENAME==ARGV[3] {
    id=$1
    if(!(id in cds) || !(id in pep)) next
    # BESTHIT columns:
    # 1 qseqid 2 pident 3 aln_len 4 qstart 5 qend 6 qlen 7 qcov 8 evalue 9 bitscore 10 flag 11 stitle
    print id, cds[id], pep[id], $2,$3,$4,$5,$6,$7,$8,$9,$10,$11
  }' cds_len.tsv pep_len.tsv "$BESTHIT" >> "$OUT"

# NO_HIT
if [[ -s "$NOHIT" ]]; then
  gawk 'BEGIN{FS=OFS="\t"}
    FILENAME==ARGV[1] {cds[$1]=$2; next}
    FILENAME==ARGV[2] {pep[$1]=$2; next}
    FILENAME==ARGV[3] {
      id=$1
      if(!(id in cds) || !(id in pep)) next
      print id, cds[id], pep[id], "","","","","","","","","NO_HIT",""
    }' cds_len.tsv pep_len.tsv "$NOHIT" >> "$OUT"
fi

echo "OK → $OUT"
echo "Filas (incluye header): $(wc -l < "$OUT")"

