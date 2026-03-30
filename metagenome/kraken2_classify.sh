#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=200G

echo "Kraken2 classification running..."

source activate kraken2

echo "Database = $1"
echo "Fw reads = $2"
echo "Rw reads = $3"
echo "Output = $4"

mkdir -p $4

for f in $2/*_1.fq.gz
do
    BASENAME=$(basename $f)
    r=${3}/${BASENAME/_1/_2}

    if [[ ! -f $r ]]; then
        echo "WARNING: Missing reverse file for $BASENAME, skipping..."
        continue
    fi

    SAMPLE=${BASENAME%_1.fq.gz}

    echo "Processing sample: $SAMPLE"

    kraken2 \
        --db $1 \
        --threads 30 \
        --paired $f $r \
        --output $4/${SAMPLE}_output.txt \
        --report $4/${SAMPLE}_report.txt \
        --use-names
done

conda deactivate

echo "DONE"

