#!/bin/bash

#SBATCH --job-name fastqc_trimmed_data
#SBATCH -A inbreh
#SBATCH -t 0-6:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_trim_fastqc_%A_%a.err
#SBATCH -o errs_outs/std_trim_fastqc_%A_%a.out
#SBATCH --array=1-33

# load up modules
module load fastqc/0.11.9

# set working directory
cd /home/sharrin2/getpop/ratsnakes/trimmed_fq
OUTDIR=/project/getpop/ratsnakes/fastqc_out/fastqc_trim



#Make array containing all the directories with data
for x in *
do
	dirs=(${dirs[@]} "${x}")
done

#Call directory, -1 will let you use array number due to count starting at 0
cd ${dirs[($SLURM_ARRAY_TASK_ID-1)]}


# run fastqc on all files, output to different directory
fastqc paired*R1* paired*R2* unpaired*R1* unpaired*R2* -t 4 -o $OUTDIR

