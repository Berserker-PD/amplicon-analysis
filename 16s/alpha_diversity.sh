#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=200G

echo "Performing alpha diversity group significance visualizations..."

mkdir -p results/visualization/alpha_diversity

source activate qiime2-amplicon

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_metrics_phylogenetic/shannon_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/shannon.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_metrics_phylogenetic/observed_features_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/richness.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_metrics_phylogenetic/faith_pd_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/faith_pd.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_metrics_phylogenetic/evenness_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/evenness.qzv

conda deactivate

echo "DONE"
echo "Download .qzv files to local computer and visualiza via view.qiime2.org"

