#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem=400G


echo "Performing differential analysis..."

mkdir -p results/differential_abundance/$1_freq.$2_samples/abundance_table
mkdir -p results/differential_abundance/$1_freq.$2_samples/composition_table
mkdir -p results/visualization/differential_abundance

source activate qiime2-amplicon

qiime feature-table filter-features \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--p-min-frequency $1 \
--p-min-samples $2 \
--o-filtered-table results/differential_abundance/$1_freq.$2_samples/abundance_table/abundance_feature_table.qza

qiime composition add-pseudocount \
--i-table results/differential_abundance/$1_freq.$2_samples/abundance_table/abundance_feature_table.qza \
--o-composition-table results/differential_abundance/$1_freq.$2_samples/composition_table/comp_abundance_feature_table.qza

qiime composition ancom \
--i-table results/differential_abundance/$1_freq.$2_samples/composition_table/comp_abundance_feature_table.qza \
--m-metadata-file metadata/metadata.txt \
--m-metadata-column $3 \
--o-visualization results/visualization/differential_abundance/$3_abundance_with_$1_freq.$2_samples.qzv

conda deactivate

echo "ANCOM analysis complete"
