#!/bin/bash

#SBATCH --job-name fastqc_rawdata
#SBATCH -A inbreh
#SBATCH -t 0-6:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_fastqc_%A_%a.err
#SBATCH -o errs_outs/std_fastqc_%A_%a.out
#SBATCH --array=1-33

# load up modules
module load fastqc/0.11.9

# set working directory
cd /home/sharrin2/getpop/ratsnakes/raw_data_ratsnake
OUTDIR=/project/getpop/ratsnakes/fastqc_out/fastqc_raw

#Make array containing all the directories with data
for x in *
do
	dirs=(${dirs[@]} "${x}")
done

#Call directory, -1 will let you use array number due to count starting at 0
cd ${dirs[($SLURM_ARRAY_TASK_ID-1)]}


# run fastqc on all files, output to different directory
fastqc *R1* *R2* -t 2 -o $OUTDIR

