#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem=500G

echo "Generating bar plot..."

mkdir -p results/visualization/barplot

source activate qiime2-amplicon

qiime taxa barplot \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--i-taxonomy results/taxonomy/taxonomy.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/barplot/taxa_bar_plot.qzv

conda deactivate

echo "Barplot created"
echo "Download .qzv files to local computer to visualize via view.qiime2.org"
