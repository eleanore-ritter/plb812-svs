#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=5                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name survivor         # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout


#change to working directory
cd $PBS_O_WORKDIR

# run SURVIVOR merge
# file with input file names
# max distance between breakpoints
# min number of supporting caller
# take the type into account (1=yes, 0=no)
# take the strands into account (1=yes, else=no)
# min size of SVs to take into account
# output file name
$HOME/programs/SURVIVOR/Debug/SURVIVOR merge files_dakapo 1000 1 1 0 0 30 dakapowb_merged.vcf
....