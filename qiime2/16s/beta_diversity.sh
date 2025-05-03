#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=200G

	#Enter the metadata column to perform PERMANOVA analysis on

echo "Performing beta diversity group significance visualizations..."

mkdir -p results/visualization/beta_diversity

source activate qiime2-amplicon

qiime emperor plot \
--i-pcoa results/core_phylogeny_metrics/jaccard_pcoa_results.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/beta_diversity/jaccard_pcoa.qzv

qiime emperor plot \
--i-pcoa results/core_phylogeny_metrics/bray_curtis_pcoa_results.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/beta_diversity/bray_curtis_pcoa.qzv

qiime emperor plot \
--i-pcoa results/core_phylogeny_metrics/unweighted_unifrac_pcoa_results.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/beta_diversity/unweighted_unifrac_pcoa.qzv

qiime emperor plot \
--i-pcoa results/core_phylogeny_metrics/weighted_unifrac_pcoa_results.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/beta_diversity/weighted_unifrac_pcoa.qzv


qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/jaccard_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--o-visualization results/visualization/beta_diversity/jaccard_significance.qzv

qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/bray_curtis_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--o-visualization results/visualization/beta_diversity/bray_curtis_significance.qzv

qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/weighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--p-pairwise \
--o-visualization results/visualization/beta_diversity/weighted_unifrac_significance.qzv

qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--p-pairwise \
--o-visualization results/visualization/beta_diversity/unweighted_unifrac_significance.qzv

qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/weighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--p-method permdisp \
--o-visualization results/visualization/beta_diversity/weighted_unifrac_significance_permdisp.qzv

qiime diversity beta-group-significance \
--i-distance-matrix results/core_phylogeny_metrics/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $1 \
--p-method permdisp \
--o-visualization results/visualization/beta_diversity/unweighted_unifrac_significance_permdisp.qzv

qiime diversity adonis \
--i-distance-matrix results/core_phylogeny_metrics/weighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula $1 \
--o-visualization results/visualization/beta_diversity/weighted_unifrac_adonis.qzv

qiime diversity adonis \
--i-distance-matrix results/core_phylogeny_metrics/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula $1 \
--o-visualization results/visualization/beta_diversity/unweighted_unifrac_adonis.qzv

conda deactivate

echo "All beta diversity analysis done"
echo "Download .qzv files to local computer and visualize using view.qiime2.org"
