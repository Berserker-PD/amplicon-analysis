#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=200G

echo "Building Phylogeny tree from filtered ASV sequences..."

source activate qiime2-amplicon

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences results/filtered_data/filtered_seqs/filtered_asv.qza \
--output-dir results/phylogeny

conda deactivate

echo "Sequences aligned and tree built complete"
echo "alignment.qza --> multiple sequence alignment using mafft"
echo "masked_alignment.qza --> filtered highly variable positions from alignment"
echo "tree.qza --> built an unrooted phylogeny tree"
echo "rooted_tree.qza --> added root to the unrooted tree"
