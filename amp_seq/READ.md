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
