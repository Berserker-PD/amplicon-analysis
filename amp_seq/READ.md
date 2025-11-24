# Installing R and R-studio

This is the workflow for meta-barcoding using various tools and packages in R

Please install R and R-studio before commencing data analysis as we will use them in analysis. You can find them at https://posit.co/download/rstudio-desktop/ Once installed make sure to get the following packages in R to setup your library

```
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# CRAN packages
cran_packages <- c("ggplot2", "openxlsx", "ape","seqinr", "adegenet", "viridis","plyr")

# Install CRAN packages
install.packages(cran_packages)

# BIOC packages
bioc_packages <- c("dada2", "phyloseq", "phangorn", "DECIPHER", "ggtree")

# Install Bioconductor packages that are missing
BiocManager::install(bioc_packages)

```
You now have all the R packages you need for this analysis. \
We have now installed everything we need and can start with analysis


# Running our analysis
Organize your raw data in a folder with forward and reverse reads and we will run the following R script

```
################################################################################
### Complete pipeline for meta-barcoding analysis ###
################################################################################

#Pleae ensure you have the following packages installed before commencing#

library(dada2)
library(ggplot2)
library(phyloseq)
library(phangorn)
library(DECIPHER)
library(openxlsx)
library(ape)
library(seqinr)
library(adegenet)
library(viridis)
library(ggtree)
library(plyr)
packageVersion('dada2')

setwd("")#Set current directory and path towards the folder containing raw reads


path <- 'data' 
list.files(path)
dir.create("results")
dir.create("saved_files")

raw_forward <- sort(list.files(path, pattern="_1.fastq.gz",
                               full.names=TRUE))

raw_reverse <- sort(list.files(path, pattern="_2.fastq.gz",
                               full.names=TRUE))

# we also need the sample names
sample_names <- sapply(strsplit(basename(raw_forward), "_"),
                       `[`,  # extracts the first element of a subset
                       1)

#Plot quality plots and save them, FYI- pdf() can be changed to jpeg()
#Change the number of plots if required

pdf("results/forward_qscore.pdf", width = 20, height = 10)
plotQualityProfile(raw_forward[1:4])
dev.off()

pdf("results/reverse_qscore.pdf", width = 20, height = 10)
plotQualityProfile(raw_reverse[1:4])
dev.off()



# place filtered files in filtered/ subdirectory
filtered_path <- file.path(path, "filtered")

filtered_forward <- file.path(filtered_path,
                              paste0(sample_names, "_R1_trimmed.fastq.gz"))

filtered_reverse <- file.path(filtered_path,
                              paste0(sample_names, "_R2_trimmed.fastq.gz"))

#Run DADA2 - this code does not truncate reads which is generally better 
out <- filterAndTrim(raw_forward, filtered_forward, raw_reverse,
                     filtered_reverse, maxN=0,
                     maxEE=c(2,2), truncQ=2, rm.phix=TRUE, compress=TRUE,
                     multithread=TRUE)
head(out)

#Learn error rates
errors_forward <- learnErrors(filtered_forward, multithread=TRUE)
errors_reverse <- learnErrors(filtered_reverse, multithread=TRUE)

#Plotting only forward profile, usually reverse is very similar but can modify to plot both

pdf("results/error_plot.pdf", width = 20, height = 10)
plotErrors(errors_forward, nominalQ=TRUE)
dev.off()


derep_forward <- derepFastq(filtered_forward, verbose=TRUE)
derep_reverse <- derepFastq(filtered_reverse, verbose=TRUE)
# name the derep-class objects by the sample names
names(derep_forward) <- sample_names
names(derep_reverse) <- sample_names

saveRDS(derep_forward, "saved_files/derep_forward.rds")
saveRDS(derep_reverse, "saved_files/derep_reverse.rds")
saveRDS(errors_forward, "saved_files/errors_forward.rds")
saveRDS(errors_reverse, "saved_files/errors_reverse.rds")


dada_forward <- dada(derep_forward, err=errors_forward, multithread=T)
dada_reverse <- dada(derep_reverse, err=errors_reverse, multithread=T)


# inspect the dada-class object
dada_forward[[1]]


merged_reads <- mergePairs(dada_forward, derep_forward, dada_reverse,
                           derep_reverse, verbose=TRUE)

# inspect the merger data.frame from the first sample
head(merged_reads[[1]])


seq_table <- makeSequenceTable(merged_reads)
dim(seq_table)

# inspect distribution of sequence lengths
table(nchar(getSequences(seq_table)))


seq_table_nochim <- removeBimeraDenovo(seq_table, method='consensus',
                                       multithread=T, verbose=TRUE)
dim(seq_table_nochim)

# which percentage of our reads did we keep?
sum(seq_table_nochim) / sum(seq_table)


get_n <- function(x) sum(getUniques(x))

track <- cbind(out, sapply(dada_forward, get_n), sapply(merged_reads, get_n),
               rowSums(seq_table), rowSums(seq_table_nochim))

colnames(track) <- c('input', 'filtered', 'denoised', 'merged', 'tabled',
                     'nonchim')
rownames(track) <- sample_names
head(track)

saveRDS(seq_table, "saved_files/seq_table.rds")
saveRDS(seq_table_nochim, "saved_files/seq_table_nochim.rds")

write.xlsx(track, 'results/dada2_summary.xlsx')

### Assign Taxonomy ### 

#Choose block as per 16S or ITS sequences. Make sure to point files to correct directory when loading them

### 16S ###
taxa <- assignTaxonomy(seq_table_nochim,
                       'SILVA/silva_nr99_v138.2_toSpecies_trainset.fa.gz',
                       multithread=F) #Add SILVA trainset file
taxa <- addSpecies(taxa, 'SILVA/silva_v138.2_assignSpecies.fa.gz') #Add SILVA species assignment


#Inspecting classification
taxa_print <- taxa  # removing sequence rownames for display only
rownames(taxa_print) <- NULL
head(taxa_print)

saveRDS(taxa, "saved_files/taxa.rds")
write.xlsx(taxa_print, "results/taxonomy.xlsx")

# Remove chloroplast and mitochondria
bad <- taxa[, "Order"] == "Chloroplast" | taxa[, "Family"] == "Mitochondria"

seqtab2 <- seq_table_nochim[,!bad]
taxa2   <- taxa[!bad, ]

# Keep only bacteria
good <- taxa2[, "Kingdom"] %in% c("Bacteria", "Archaea")

seqtab3 <- seqtab2[,good]
taxa3   <- taxa2[good, ]

# Optional: drop unassigned phylum
good2 <- !is.na(taxa3[, "Phylum"]) & taxa3[, "Phylum"] != ""

seqtab.clean <- seqtab3[,good2]
taxa.clean   <- taxa3[good2, ]


### ITS ###

unite.ref <- "UNITE/sh_general_release_s_19.02.2025/sh_general_release_dynamic_s_19.02.2025_dev.fasta"  # CHANGE ME to location on your machine
taxa <- assignTaxonomy(seq_table_nochim, unite.ref, multithread = TRUE, tryRC = TRUE)

saveRDS(taxa, file = "saved_files/taxa.rds")

#No need to filter anymore as using specific fungal dataset. If using an eukaryotic dataset, filtering of reads might be required


### Phylogenetic tree ###
sequences <- getSequences(seq_table_nochim)
names(sequences) <- sequences  # this propagates to the tip labels of the tree
alignment <- AlignSeqs(DNAStringSet(sequences), anchor=NA)

saveRDS(alignment, file = "saved_files/alignment.rds")

phang_align <- phyDat(as(alignment, 'matrix'), type='DNA') #Converting alignment for phangorn
dm <- dist.ml(phang_align) #maximum likelyhood distances
treeNJ <- NJ(dm)  # note, tip order != sequence order
treeNJ <- ladderize(treeNJ)

saveRDS(treeNJ, file = "saved_files/NJ_tree.rds")


### Phyloseq ###

#Label the sample name as 'sample_name' and provide as many variables as possible (3 or more recommended). Will not work with 1 variable

sample_data <- read.table('metadata.txt', header=TRUE, row.names="sample_name") #Change as per file name

#Make sure you are reading correct files. IMP- based on 16S/ITS your taxa file will be 'taxa.clean' or 'taxa' respectively

physeq <- phyloseq(otu_table(seq_table_nochim, taxa_are_rows=FALSE),
                   sample_data(sample_data),
                   tax_table(taxa.clean), #CHECK ME
                   phy_tree(treeNJ))

# Optional filtering for low-abundance taxa
physeq <- filter_taxa(physeq, function(x) sum(x) > 10, TRUE)

# Optional reassigning missing phylum names to unclassified
tax_table(physeq)[, "Phylum"] <- as.character(tax_table(physeq)[, "Phylum"])
tax_table(physeq)[is.na(tax_table(physeq)[, "Phylum"]), "Phylum"] <- "Unclassified"

### Alpha Diversity ###

#Can change measures as required
#Change x to desired variable mentioned in metadata

a <- plot_richness(
  physeq,
  x = "group",
  measures = c("Shannon", "Simpson", "Fisher", "Chao1", "Observed"),
  color = "group"
) +
  geom_boxplot(alpha = 0.4, outlier.shape = NA, color = "black") +   # adds boxplots behind points
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +                  # jittered points for clarity
  theme_bw(base_size = 14) +                                         # cleaner base theme
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 12, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 12),
    axis.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 13, face = "bold"),
    legend.position = "top",
    legend.title = element_blank()
  ) +
  labs(
    x = "Sample Group",
    y = "Alpha Diversity Index Value",
    title = "Alpha Diversity Metrics" #CHANGE AS DESIRED
  )

pdf("results/alpha_diversity.pdf", width = 20, height = 10)
a
dev.off()

### Beta Diversity ###

#Provided with four main types of ordinations, can change as required.
#Change 'color' and 'shape' to any of your variables in metadata

ord <- ordinate(physeq, 'MDS', 'euclidean')

pdf("results/beta_diversity_MDS.pdf", width = 20, height = 10)
plot_ordination(physeq, ord, type='samples', color='group',
                title='PCA of the samples - Euclidean distance')
dev.off()

ord1 <- ordinate(physeq, 'NMDS', 'bray')
pdf("results/beta_diversity_NMDS.pdf", width = 20, height = 10)
plot_ordination(physeq, ord, type='samples', color='group',
                title='PCA of the samples - Bray curtis')
dev.off()

ordu = ordinate(physeq, "PCoA", "unifrac", weighted=TRUE)
pdf("results/beta_diversity_PCoA_weighted.pdf", width = 20, height = 10)
plot_ordination(physeq, ordu, color="group", shape="status", title = 'PCoA weighted Unifrac')
dev.off()

ordu1 = ordinate(physeq, "PCoA", "unifrac", weighted=F)
pdf("results/beta_diversity_PCoA_unweighted.pdf", width = 20, height = 10)
plot_ordination(physeq, ordu1, color="group", shape="status", title = 'PCoA un-weighted Unifrac')
dev.off()

### SPLIT PLOT ###

#Choose prefered ordination (Unifrac weighted  by default) and 'color' 'shape' 'label' as per metadata

p1 = plot_ordination(physeq, ordu, type="split", color="Phylum", shape="group", label="biochar") 
p1 = p1 + geom_point(size=7, alpha=0.75) + scale_shape_manual(values=seq(15,25)) #CHANGE VALUES IF YOUR DATA HAS MANY VARIABLES more than 10
p1 = p1 + scale_colour_brewer(type="qual", palette="Paired")
pdf("results/beta_diversity_split_plot.pdf", width = 20, height = 10)
p1 + ggtitle("Split plot for Samples and Taxa")
dev.off()

p2 = plot_ordination(physeq, ordu, color="biochar", shape="AMF")
p2 = p2 + geom_point(size=7, alpha=0.75)
p2 = p2 + scale_colour_brewer(type="qual", palette="Set1")
pdf("results/beta_diversity_weighted_unifrac.pdf", width = 20, height = 10)
p2 + ggtitle("PCoA on weighted-UniFrac distance")
dev.off()

p3 = plot_ordination(physeq, ordu1, color="biochar", shape="AMF")
p3 = p3 + geom_point(size=7, alpha=0.75)
p3 = p3 + scale_colour_brewer(type="qual", palette="Set1")
pdf("results/beta_diversity_unweighted_unifrac.pdf", width = 20, height = 10)
p3 + ggtitle("MDS/PCoA on un-weighted-UniFrac distance")
dev.off()

### Abundant families ###

#Set for top 100 families, 100 phylum and 20 species but change as your data fits
#Change x and facet_wrap to desired metadata variable

top100 <- names(sort(taxa_sums(physeq), decreasing=TRUE))[1:100]
physeq_top100 <- transform_sample_counts(physeq, function(OTU) OTU/sum(OTU))
physeq_top100 <- prune_taxa(top100, physeq_top100)
pdf("results/abundant_families.pdf", width = 20, height = 10)
plot_bar(physeq_top100, x='group', fill='Family') +
  facet_wrap(~group, scales='free_x') + ggtitle("Top 100 Abundant Families")
dev.off()

top100 <- names(sort(taxa_sums(physeq), decreasing=TRUE))[1:100]
physeq_top100 <- transform_sample_counts(physeq, function(OTU) OTU/sum(OTU))
physeq_top100 <- prune_taxa(top100, physeq_top100)
pdf("results/abundant_phyla.pdf", width = 20, height = 10)
plot_bar(physeq_top100, x='group', fill='Phylum') +
  facet_wrap(~group, scales='free_x') + ggtitle("Top 100 Abundant Phyla")
dev.off()

top20 <- names(sort(taxa_sums(physeq), decreasing=TRUE))[1:20]
physeq_top20 <- transform_sample_counts(physeq, function(OTU) OTU/sum(OTU))
physeq_top20 <- prune_taxa(top20, physeq_top20)
pdf("results/abundant_species.pdf", width = 20, height = 10)
plot_bar(physeq_top20, x='group', fill='Species') +
  facet_wrap(~group, scales='free_x') + ggtitle("Top 20 Abundant Species")
dev.off()



### Abundance tree ###

# Can specify '#####' at Phylum,Species,Family or Order level. Mention the level before entry. Currently set at Phylum

abu_tree <- subset_taxa(physeq, Phylum %in% c('#####'))
plot_tree(abu_tree, ladderize='left', size='abundance',
          color='when', label.tips='Family')


plot_tree(physeq, ladderize = 'left', color = 'biochar') + coord_polar(theta = "y")

```

