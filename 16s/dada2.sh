#!/bin/bash
#SBATCH --partition=vhmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=200G

echo "Performing DADA2 denoising..."
echo "This may take a while..."

	#Input your parameters to truncate and trim forward and/or reverse reads along with your run command
	#First variable=truncate fw reads at (input)bp
	#Second variable=truncate rv reads at (input)bp
	#Third variable=trim fw reads (input)bp from 5' end
	#Fourth variable=trim rv reads (input)bp from 5' end
	#Use the visualized_sequences.qzv file to check for quality in sequencnes to truncate and trim
	#You need to put in a truncate value, If you do not wish to trim the sequences,enter 0 as input

mkdir -p results/dada2/representative_sequences
mkdir -p results/dada2/feature_table
mkdir -p results/dada2/dada2_stats

source activate qiime2-amplicon

qiime dada2 denoise-paired \
--i-demultiplexed-seqs results/trimmed_sequences/trimmed_sequences.qza \
--p-trunc-len-f $1 \
--p-trunc-len-r $2 \
--p-trim-left-f $3 \
--p-trim-left-r $4 \
--o-representative-sequences results/dada2/representative_sequences/asv.qza \
--o-table results/dada2/feature_table/feature_table.qza \
--o-denoising-stats results/dada2/dada2_stats/dada2_stats.qza

conda deactivate

echo "DADA2 denoising complete" 
