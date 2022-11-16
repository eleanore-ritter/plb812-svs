#!/bin/bash --login
#SBATCH --time=03:59:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=500GB
#SBATCH --job-name pbsv
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

#Run pbsv
echo "Running pbsv to discover signatures of structural variation"

# run pbsv discover to discover signatures of structural variation
# input bam file, sorted and with read groups added
# output svsig.gz file

pbsv discover # FINISH SCRIPT HERE

echo "Calling structural variants and assigning genotypes with pbsv"

# run pbsv call to call structural variants and assign genotypes
# reference genome fasta file
# svsig.gz file produced from pbsv discover
# output vcf file

pbsv call # FINISH SCRIPT HERE

echo "Done"
