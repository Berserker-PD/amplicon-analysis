#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G

echo "Plotting alpha-rarefaction curve..."
echo "This can be useful to see sequencing depth and pick appropriate sequencing depth"

	#You must have a rough number in mind from fitered feature table.qzv
	#Enter a max value to see sequencing depth up-to this frequency

mkdir -p results/rarefaction

source activate qiime2-amplicon

qiime diversity alpha-rarefaction \
--i-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--p-metrics shannon \
--p-metrics simpson \
--m-metadata-file metadata/metadata.txt \
--p-max-depth $1 \
--o-visualization results/rarefaction/rarefaction_curve.qzv

conda deactivate

echo "Rarefaction plot generated"
echo "Download .qzv file to local computer and visualiza via view.qiime2.org"
