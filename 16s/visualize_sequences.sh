#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Visualizing sequences..."

mkdir -p results/visualization

source activate qiime2-amplicon

qiime demux summarize \
--i-data results/imported_sequences/imported_sequences.qza \
--o-visualization results/visualization/visualized_sequences.qzv

conda deactivate

echo "Sequences visualized"
echo "Download the file visualized_sequences.qzv to local computer and use view.qiime2.org for visualizations"
