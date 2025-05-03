#This is not to be run on cluster
#You can get the qiime database on your local PC and run the following commands after you install empress plugin in qiime2 locally
#To install this, first natively install qiime 2 on your system (google)
#Then install empress plugin in your qiime2 environment (also google)
#Run this code on your HPC results folder

conda activate qiime2-amplicon

qiime empress community-plot \
--i-tree results/phylogeny/rooted_tree.qza \
--i-feature-table results/filtered_data/filtered_table/filtered_feature_table_wo_contaminants.qza \
--m-sample-metadata-file metadata/metadata.txt \
--m-feature-metadata-file results/taxonomy/taxonomy.qza \
--o-visualization empress_phylogeny.qzv

conda deactivate

