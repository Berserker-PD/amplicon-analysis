#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=200G

echo "Performing alpha diversity group significance visualizations..."

	#Enter metadata column for analysis in rainplots
	#Edit metadata column manually in anova code

mkdir -p results/visualization/alpha_diversity
mkdir -p results/alpha_diversity/distance_matrix
mkdir -p results/alpha_diversity/stats

source activate qiime2-amplicon

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/shannon_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/shannon.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/observed_features_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/richness.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/faith_pd_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/faith_pd.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/evenness_vector.qza \
--m-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/alpha_diversity/evenness.qzv



qiime stats alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/shannon_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-columns $1 $2 \
--o-distribution results/alpha_diversity/distance_matrix/shannon_dist.qza \
--o-stats results/alpha_diversity/stats/shannon_stats.qza \
--o-raincloud results/visualization/alpha_diversity/shannon_raincloud.qzv

qiime stats alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/observed_features_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-columns $1 $2 \
--o-distribution results/alpha_diversity/distance_matrix/richness_dist.qza \
--o-stats results/alpha_diversity/stats/richness_stats.qza \
--o-raincloud results/visualization/alpha_diversity/richness_raincloud.qzv

qiime stats alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/faith_pd_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-columns $1 $2 \
--o-distribution results/alpha_diversity/distance_matrix/faith_pd_dist.qza \
--o-stats results/alpha_diversity/stats/faith_pd_stats.qza \
--o-raincloud results/visualization/alpha_diversity/faith_pd_raincloud.qzv

qiime stats alpha-group-significance \
--i-alpha-diversity results/core_phylogeny_metrics/evenness_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-columns $1 $2 \
--o-distribution results/alpha_diversity/distance_matrix/evenness_dist.qza \
--o-stats results/alpha_diversity/stats/evenness_stats.qza \
--o-raincloud results/visualization/alpha_diversity/evenness_raincloud.qzv


qiime longitudinal anova \
--m-metadata-file results/core_phylogeny_metrics/shannon_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula 'shannon_entropy ~ group * time' \
--o-visualization results/visualization/alpha_diversity/shannon_anova.qzv

qiime longitudinal anova \
--m-metadata-file results/core_phylogeny_metrics/observed_features_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula 'observed_features ~ group * time' \
--o-visualization results/visualization/alpha_diversity/richness_anova.qzv

qiime longitudinal anova \
--m-metadata-file results/core_phylogeny_metrics/faith_pd_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula 'faith_pd ~ group * time' \
--o-visualization results/visualization/alpha_diversity/faith_pd_anova.qzv

qiime longitudinal anova \
--m-metadata-file results/core_phylogeny_metrics/evenness_vector.qza \
--m-metadata-file metadata/metadata.txt \
--p-formula 'pielou_evenness ~ group * time' \
--o-visualization results/visualization/alpha_diversity/evenness_anova.qzv


conda deactivate

echo "DONE"
echo "Download .qzv files to local computer and visualiza via view.qiime2.org"
