#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=100G

echo "Performing FastQC and MultiQC..."

IN_DIR=$1
OUT_DIR=$2

echo "IN_DIR=$1"
echo "OUT_DIR=$2"

mkdir -p $OUT_DIR

source activate qc

for read in "$IN_DIR"/*/*.fq.gz
do
echo "Processing $read"

fastqc "$read" -o "$OUT_DIR" --threads 30
done

cd "$OUT_DIR"
multiqc .

conda deactivate

echo "DONE"
