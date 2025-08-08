# Installing R and R-studio

This is the workflow for amp-seq using various tools and packages

Please install R and R-studio before commencing data analysis as we will use them in analysis. You can find them at https://posit.co/download/rstudio-desktop/ Once installed make sure to get the following packages in R to setup your library

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

Once done, just type **WSL** in you command prompt or powershell to activate and **exit** to deactivate \


We have now installed everything we need and can start with analysis

# Data Analysis
## Getting sample IDs

We can now get our sample ids from our raw reads which is useful to generate a metadata file and for trimming sequences. \
Organize your raw data in a folder with forward and reverse reads and we will generate the samples file from running *filter_seqs.sh* in a directory above the raw_fastq folder

```
cd $1

ls *_R1_001.fastq.gz | cut -f1 -d "_" >samples.txt

cp samples.txt ..
```
Here the first variable is where you define the file path to your directory. Change the (_R1_001.fastq.gz) to indicate what is the suffix of your samples (L1.fq or R1.fq or anything else) \
After succesfull implementation, a file samples.txt will be generated in your designated raw_dna folder.\
\
\

