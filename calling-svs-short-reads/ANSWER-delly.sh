#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name delly            # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

# run delly call
# -o output file
# -g reference genome fasta file
# input files

delly call \
-o delly.bcf \
-g plb812-Vvinifera.fa \
plb812-merlotwt-sr.bam

bcftools view delly.bcf > delly.vcf
rm delly.bcf*

echo "Done"
