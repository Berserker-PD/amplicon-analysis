#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=100G

echo "Running Bracken on all samples..."

KRAKEN_DIR=$1
OUT_DIR=$2
DB=$3
READ_LEN=$4   # e.g. 150

mkdir -p "$OUT_DIR"

echo "Kraken dir = $KRAKEN_DIR"
echo "Output dir = $OUT_DIR"
echo "DB = $DB"
echo "Read length = $READ_LEN"

source activate bracken

for report in "$KRAKEN_DIR"/*_report.txt
do
    BASENAME=$(basename "$report")
    SAMPLE=${BASENAME%_report.txt}

    echo "Processing $SAMPLE"

    bracken \
        -d "$DB" \
        -i "$report" \
        -o "$OUT_DIR/${SAMPLE}_bracken_genus.txt" \
        -r "$READ_LEN" \
        -l G \
        -t 30

done

#for more options, change -l to G(genus), P(Phylum), S(Species)

conda deactivate

echo "DONE"
