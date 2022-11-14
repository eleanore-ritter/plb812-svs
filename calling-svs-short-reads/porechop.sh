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
threads=20
length=300 #Needs to be >0 or else reads of 0 length will be included!

#Change the following to match your file names
input="combined.fastq.gz"
output1="trimmed.fastq.gz"

#Trim reads
echo "Trimming fastq files with porechop"

# run porechop to trim reads
# -i input fastq.gz file
# -o output trimmed fastq.gz file
# -t threads/ cpus per task to use
# --min_trim_size minimum base pairs needed to algin to adapter
# --extra_end_trim the amount of base pairs to trim past the adapter match to make sure that it is removed
# --end_threshold percent of base pairs required to align
# --middle_threshold percent of base pairs required to align when adapter is found in the middle of a read
# --extra_middle_trim_good_side number of extra bases trimmed after an adapter found in the middle of the read
# --extra_middle_trim_bad_side number of extra bases trimmed before an adapter that is found in the middle of the read
# --min_split_read_size the minimum size to keep of a split read (a read with an adapter in the middle)

porechop \
-i ${input} \
-o ${output1} \
-t ${threads} \
--min_trim_size 5 \
--extra_end_trim 2 \
--end_threshold 80 \
--middle_threshold 90 \
--extra_middle_trim_good_side 2 \
--extra_middle_trim_bad_side 50 \
--min_split_read_size ${length}

echo "Done"