#!/bin/bash --login
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=500GB
#SBATCH --job-name minimap2
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda=""

#change to working directory
cd $PBS_O_WORKDIR

export PATH="${conda}/envs/plb812-svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/plb812-svs/lib:${LD_LIBRARY_PATH}"

#Set the following variables
path1="" # Path where reference genome is
path2="" # Path where output files should go
ref="" # Reference genome name
dt="" # Datatype (ont, pac, hifi, etc.)
fastq="" # Input fastq file - should be trimmed and filtered
threads="" # Number of threads/CPUs per task to use

#Make minimap2 index
echo "Creating minimap2 index"

# Run minimap2 to generate index
# -x specify datatype (ont, pac, hifi, etc.)
# -d output minimap2 index file
# reference genome fasta file

minimap2 \
-x ${dt} \
-d ${path2}/${ref}.mmi \
${path1}/*.fa

#Run minimap2
echo "Running minimap2"

# Run minimap2 to map reads to reference genome
# -ax sets output as SAM (a) and allows datatype to be preset (x)
# minimap2 index file generated above
# input fastq file - should be trimmed and filtered
# --MD output the MD tag
# -t number of threads to parallelize with
# output sam file

minimap2 \
-ax ${dt} \
${path2}/${ref}.mmi \
${fastq} \
--MD \
-t ${threads} > ${path2}/aln.sam

#Make sorted bam file and remove sam file
echo "Creating sorted bam file"

# Run samtools sort to sort reads in sam file
# Input sam file generated above
# Output bam file with sorted reads

samtools sort ${path2}/aln.sam > ${path2}/aln-sorted.bam

# Remove sam file, we don't need it anymore
rm ${path2}/aln.sam

echo "Done"
