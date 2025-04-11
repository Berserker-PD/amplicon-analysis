#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Clipping primers..."

	#These set of command are for paired sequences. To modify or change to single end sequences, please refer to documentation on qiime2.org
	#EVEN IF YOU DO NOT HAVE PRIMERS TO TRIM, DO RUN THIS COMMAND
	#IT WILL NOT TRIM YOUR SEQUENCES BUT WILL GIVE THE APPROPRIATE FILENAME TO BE USED IN FURTHER STEPS

mkdir -p results/trimmed_sequences


source activate qiime2-amplicon

qiime cutadapt trim-paired \
--i-demultiplexed-sequences results/imported_sequences/imported_sequences.qza \
--p-anywhere-f $1 \
--p-anywhere-r $2 \
--o-trimmed-sequences results/trimmed_sequences/trimmed_sequences.qza

conda deactivate

echo "Trimmed primers from sequences"
