#Installing conda environment

This is the workflow for amp-seq conda env

First we need to make the conda env to install packages

```
conda create -n amp_seq
```

Once env is created, we need to activate and install packages
```
conda activate amp_seq

conda install -c conda-forge -c bioconda -c defaults \
cutadapt r-base rstudio r-tidyverse \
r-vegan r-dendextend r-viridis \
bioconductor-phyloseq bioconductor-deseq2 bioconductor-dada2 \
bioconductor-decipher bioconductor-decontam r-biocmanager r-matrix libopenblas
```

Install all these packages and deactivate the env
```
conda deactivate amp_seq
```

We have now installed everything we need and can start with analysis

#Data Analysis
##Getting sample IDs

We can now get our sample ids from our raw reads.
Assuming you have organized data in separate F and R folders for forward and reverse reads and kept these directories in the raw_dna directory, we will generate the samples file from samples.sh

```
echo "Generating sample file names "
echo "Path for files = $1"
echo "File suffix = $2"

cd $1

ls *$2 | cut -f1 -d "_" > samples.txt

cp samples.txt ..

echo "samples.txt file created"
echo "file stored in raw_dna folder"
```
Here the first variable is where you define the file path to your F or R reads directory. The second variable is used to indicate what is the suffix of your samples (L1.fq or R1.fq or anything else)
After succesfull implementation, a file samples.txt will be generated in your designated raw_dna folder.
P.S. keep an eye out on slurm-******.out file for completion and/or error notice.
