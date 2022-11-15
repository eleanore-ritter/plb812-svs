#!/bin/bash --login
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=500GB
#SBATCH --job-name prep_ont_reads
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

#Set variables
length=300 #Needs to be >0 or else reads of 0 length will be included!
quality=0 #guppy filtered on quality of 7

#Change the following to match your file names
input="trimmed.fastq.gz"
output="clean.fastq.gz"
lambda="${path1}/lambda_3.6kb.fasta"


#Filter reads
echo "Filtering and trimming reads"

# Unzip and read input file into NanoLyse
# Run NanoLyse remove reads mapping to the lambda phage genome from a fastq file
# -r lambda reference genome file
# Run NanoFilt to filter reads based on quality and length
# -q filter on a minimum average read quality score
# -l filter on a minimum read length
# zip resulting file and create output file

zcat ${input} | \
NanoLyse -r ${lambda} | \
NanoFilt -q ${quality} -l ${length} | \
gzip > ${output}

echo "Done"