#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=10G

echo "Visualizing metadata file"

source activate qiime2-amplicon

qiime metadata tabulate \
--m-input-file raw_dna/metadata.txt \
--o-visualization results/metadata.qzv

conda deactivate

echo "Visualization complete"

