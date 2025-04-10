#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=10G

echo "Visualizing metadata file..."

source activate qiime2-amplicon

qiime metadata tabulate \
--m-input-file metadata/metadata.txt \
--o-visualization results/visualization/metadata.qzv

conda deactivate

echo "Visualization complete"
echo "Download the file metadata.qzv to local computer and use view.qiime2.org for visualization"
