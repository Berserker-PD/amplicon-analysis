#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Exporting phylogeny tree..."

mkdir -p results/phylogeny/newick_file

source activate qiime2-amplicon

qiime tools export \
--input-path results/phylogeny/tree.qza \
--output-path results/phylogeny/newick_file/unrooted_tree

qiime tools export \
--input-path results/phylogeny/rooted_tree.qza \
--output-path results/phylogeny/newick_file/rooted_tree

qiime tools export \
--input-path results/phylogeny/alignment.qza \
--output-path results/phylogeny/newick_file/alignment

qiime tools export \
--input-path results/phylogeny/masked_alignment.qza \
--output-path results/phylogeny/newick_file/masked_aligment


conda deactivate

echo "Phylogeny exported as newick file"
echo "File can be viewed in supporting online or local softwares"
