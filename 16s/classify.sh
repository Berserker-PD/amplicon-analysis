#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem=500G

echo "Classifying reads and assigning taxonomy..."
echo "Mapping taxonomy assignment to metadata and visualizing"
echo "This can take time depending on sample density"

mkdir -p results/taxonomy
mkdir -p results/visualization/taxonomy

	#This step uses a classifier to classify ASV reads and assign them into taxonomy
	#This file uses Silva 138 naive bayes classifier which assigns taxonomy at 99% similarity
	#If you wish to use a different classifier, please replace the classifier in the classifier directory and modify the code
	#You can train your own classifiers or get them from resources.qiime2.org

source activate qiime2-amplicon

qiime feature-classifier classify-sklearn \
--i-classifier classifier/*.qza \
--i-reads results/dada2/representative_sequences/asv.qza \
--o-classification results/taxonomy/taxonomy.qza

qiime metadata tabulate \
--m-input-file results/taxonomy/taxonomy.qza \
--o-visualization results/visualization/taxonomy/taxonomy.qzv

conda deactivate

echo "All steps complete"
echo "Please download .qzv files to local computer and visualize via view.qiime2.org"
