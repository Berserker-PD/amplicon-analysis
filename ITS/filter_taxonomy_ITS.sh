#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem=500G

echo "Removing contaminants..."
echo "Filtereing feature table and representative sequences..."

	#Here, the contaminants such as Chloroplast, Mitochondria, and unclassified reads from amplified data will be removed
	#You can also provide with a minimum frequency count so samples haveing reads less then specified frequency will be removed
	#It is usually good to remove low sequences which did not amplify well and can cause misleading results
	#If you do not wish to filter sequences, input 0

mkdir -p results/filtered_data/filtered_table
mkdir -p results/filtered_data/filtered_seqs
mkdir -p results/visualization/filtered_table

source activate qiime2-amplicon

qiime taxa filter-table \
--i-table results/dada2/feature_table/feature_table.qza \
--i-taxonomy results/taxonomy/taxonomy.qza \
--p-mode contains \
--p-include p__ \
--p-exclude 'p__;' \
--o-filtered-table results/filtered_data/filtered_table/feature_table_wo_contaminants.qza \

qiime feature-table filter-samples \
--i-table results/filtered_data/filtered_table/feature_table_wo_contaminants.qza \
--p-min-frequency $1 \
--o-filtered-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \

qiime feature-table filter-seqs \
--i-data results/dada2/representative_sequences/asv.qza \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--o-filtered-data results/filtered_data/filtered_seqs/filtered_asv.qza

qiime feature-table summarize \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--m-sample-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/filtered_table/filtered_feature_table_wo_contaminants.qzv

conda deactivate

echo "feature table and sequences filtered. Contaminants removed"
