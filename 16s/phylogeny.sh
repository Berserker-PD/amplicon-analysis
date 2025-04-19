#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=50G

echo "Building Phylogeny tree from filtered ASV sequences..."

source activate qiime2-amplicon

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences results/filtered_data/filtered_seqs/filtered_asv.qza \
--output-dir results/phylogeny

mkdir -p results/phylogeny/newick_file

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

echo "Sequences aligned and tree built complete"
echo "alignment.qza --> multiple sequence alignment using mafft"
echo "masked_alignment.qza --> filtered highly variable positions from alignment"
echo "tree.qza --> built an unrooted phylogeny tree"
echo "rooted_tree.qza --> added root to the unrooted tree"
echo "Phylogeny exported as newick file"
echo "File can be viewed in supporting online or local softwares"
