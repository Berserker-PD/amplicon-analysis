# Installing R and R-studio

This is the workflow for amp-seq using various tools and packages

Please install R and R-studio before commencing data analysis as we will use them in analysis. You can find them at https://posit.co/download/rstudio-desktop/. Once installed make sure to get the following packages in R to setup your library

```
install.packages("ggplot2")

install.packages("BiocManager")
packageVersion("BiocManager")

BiocManager::install("dada2")
packageVersion("dada2")
```
You now have all the R packages you need for this analysis.

# Installing WSL

This is an optional step if you are on Windows OS. If so, we will now get Windows Subset for Linux (WSL) installed on our system.
This helps us to have a Linux based language operational on Windows device. You can get the Ubuntu distribution from the offical WSL webpage (https://learn.microsoft.com/en-us/windows/wsl/install)

Once done, just type *WSL* in you command promp or powershell to activate and *exit* to deactivate

```
conda env create \
  --name qiime2-amplicon-2024.10 \
  --file https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2024.10/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml
```
```
conda env create \
  --name qiime2-amplicon-2025.4 \
  --file https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2025.4/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml
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

# Data Analysis
## Getting sample IDs

We can now get our sample ids from our raw reads. \
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
Here the first variable is where you define the file path to your F or R reads directory. The second variable is used to indicate what is the suffix of your samples (L1.fq or R1.fq or anything else) \
After succesfull implementation, a file samples.txt will be generated in your designated raw_dna folder.\
\
\
P.S. keep an eye out on slurm-******.out file for completion and/or error notice.
