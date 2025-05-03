#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=200G

echo "Computing common diversity metrics..."
echo "This analysis will generate a bunch of files"

	#Input your sampling depth as first variable for analysis

source activate qiime2-amplicon

qiime diversity core-metrics-phylogenetic \
--i-phylogeny results/phylogeny/rooted_tree.qza \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--p-sampling-depth $1 \
--m-metadata-file metadata/metadata.txt \
--output-dir results/core_phylogeny_metrics

conda deactivate

echo "Diversity matrix analysed"

