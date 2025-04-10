#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Clipping primers..."

	#These set of command are for paired sequences. To modify or change to single end sequences, please refer to documentation on qiime2.org

mkdir -p results/trimmed_sequences

f_primer=$1
r_primer=$2

source activate qiime2-amplicon

qiime cutadapt trim-paired \
--i-demultiplexed-sequences results/imported_sequences/imported_sequences.qza \
--p-front-f echo "$f_primer" \
--p-front-r echo "$r_primer" \
--o-trimmed-sequences results/trimmed_sequences/trimmed_sequences.qza

conda deactivate

echo "Trimmed primers from sequences"
