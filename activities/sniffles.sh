#!/bin/bash --login
#SBATCH --time=03:59:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=500GB
#SBATCH --job-name sniffles
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

#Set the following variables
threads=4 # Number of threads to use

#Make sniffles directory and change directory

#Run sniffles
echo "Running sniffles on Merlot WT"

# run sniffles to call and genotype SVs
# --input input bam file
# --reference reference genome fasta file
# -v output vcf file
# -t number of threads to use

sniffles # FINISH SCRIPT HERE AND BE SURE TO SPECIFY THREADS

echo "Done"
