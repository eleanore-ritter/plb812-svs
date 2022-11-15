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
ID="" # ID for read group
PU="" # PU for read group
PL="" # PL for read group
LB="" # LB for read group
SM="" # SM for read group

#Make minimap2 index
echo "No index detected, creating index"

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
# -a sets output as SAM
# --MD output the MD tag
# --eqx write =/X CIGAR operators
# -L write CIGAR with >65535 ops at the CG tag
# -O gap open penalty
# -E gap extension penalty; a k-long gap costs min{O1+k*E1,O2+k*E2}
# -B  mismatch penalty (larger value for lower divergence) 
# --secondary do not output secondary alignments
# -z Z-drop score and inversion Z-drop score
# -r chaining/alignment bandwidth and long-join bandwidth
# -Y use soft clipping for supplementary alignments
# minimap2 index file generated above
# input fastq file - should be trimmed and filtered
# -t number of threads to parallelize with
# output sam file

minimap2 \
-a --MD --eqx -L -O 5,56 -E 4,1 -B 5 --secondary=no -z 400,50 -r 2k -Y \
${path1}/${ref}.mmi \
${fastq} \
-t ${threads} > ${path2}/aln.sam

#Make sorted bam file and remove sam file
echo "Creating sorted bam file"

cd ${path2}

# Run samtools sort to sort reads in sam file
# Input sam file generated above
# Output bam file with sorted reads

samtools sort aln.sam > aln-sorted.bam
rm aln.sam

# Run samtools addreplacerg (necessary for pbsv)
# -r read group being added
# -o output bam file
# input file

samtools addreplacerg \
-r "@RG\tID:$ID\tLB:$LB\tPL:$PL\tSM:$SM\tPU:$PU" \
-o aln-sorted-rg.bam \
aln-sorted.bam

echo "Done"