#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Importing data..."

#edit input type and format as per sample data
#casava1.8 cannot input reads from different folders. If using this type of data, import from a merged reads folder
source activate qiime2-amplicon

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--input-path raw_dna/merged \
--output-path results/imported_sequences/imported_sequences.qza

conda deactivate

echo "Data imported"
