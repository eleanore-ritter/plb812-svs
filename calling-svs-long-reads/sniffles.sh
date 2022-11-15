#!/bin/bash --login
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=500GB
#SBATCH --job-name sniffles
#SBATCH --output=%x-%j.SLURMout

# NOTE: this script has not been tested with the update from sniffles to sniffles2

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

#Set the following variables
path1="" # Path where reference genome is
sample="" # Sample name
threads=4 # Number of threads to use

#Make sniffles directory and change directory
mkdir sniffles
cd sniffles

#Run sniffles
echo "Running sniffles on ${sample}"

# run sniffles to call and genotype SVs
# --input input bam file
# --reference reference genome fasta file
# -v output vcf file
# -t number of threads to use

sniffles --input ../*.bam \
--reference ${path1}/*.fa \
-v ${sample}_sniffles.vcf \
-t ${threads}

echo "Done"