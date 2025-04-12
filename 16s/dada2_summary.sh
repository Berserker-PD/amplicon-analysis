#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Summarizing DADA2 stats and creating feature table..."
echo "Generating ASVs from representative sequences..."

mkdir -p results/visualization/dada2_summary

source activate qiime2-amplicon

qiime metadata tabulate \
--m-input-file results/dada2/dada2_stats/dada2_stats.qza \
--o-visualization results/visualization/dada2_summary/dada2_summary.qzv

qiime feature-table summarize \
--i-table results/dada2/feature_table/feature_table.qza \
--m-sample-metadata-file metadata/metadata.txt \
--o-visualization results/visualization/dada2_summary/feature_table.qzv

qiime feature-table tabulate-seqs \
--i-data results/dada2/representative_sequences/asv.qza \
--o-visualization results/visualization/dada2_summary/asv_seqs.qzv

conda deactivate

echo "All stats summarized, please download .qzv files to local computer and visualize via view.qiime2.org"
