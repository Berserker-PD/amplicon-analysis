#!/bin/bash
#SBATCH --partition=cpu-standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

echo "Generating sample file names "
echo "Path for files = $1"
echo "File suffix = $2"

cd $1

ls *$2 | cut -f1 -d "_" > samples.txt

cp samples.txt ..

echo "samples.txt file created"
echo "file stored in raw_dna folder"
