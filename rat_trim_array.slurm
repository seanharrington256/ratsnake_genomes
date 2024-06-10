#!/bin/bash

#SBATCH --job-name trim
#SBATCH -A inbreh
#SBATCH -t 0-24:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24   
#SBATCH --mem=36G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_trim_%A_%a.err
#SBATCH -o errs_outs/std_trim_%A_%a.out
#SBATCH --array=1-33

#make sure cpus match threds

# Try out trimming using adapters.fa from bbduk

#Load modules
module load trimmomatic/0.39

#Set working directory
cd /home/sharrin2/getpop/ratsnakes/raw_data_ratsnake

# Make bash array of directories to iterate over
for x in *
do
	dirs=(${dirs[@]} "${x}")
done


# Move into directory, -1 will let you use array number due to count starting at 0
cd ${dirs[($SLURM_ARRAY_TASK_ID-1)]}

#Lable reads 
FORWARD=*R1*
REVERSE=*R2*
ADAPTERS='/project/getpop/adapters.fa'

#make file location
SAMPLE=$(echo ${dirs[($SLURM_ARRAY_TASK_ID-1)]} | cut -f 1 -d '_')
OUT_DIR=/project/getpop/ratsnakes/trimmed_fq/trim_read_$SAMPLE

mkdir $OUT_DIR



o_for="$(basename $FORWARD)"
o_rev="$(basename $REVERSE)"

#script for trimmed reads
trimmomatic PE -threads 24 $FORWARD $REVERSE\
    $OUT_DIR/paired-$o_for $OUT_DIR/unpaired-$o_for\
    $OUT_DIR/paired-$o_rev $OUT_DIR/unpaired-$o_rev\
    ILLUMINACLIP:$ADAPTERS:2:30:10:8:true\
    LEADING:10 TRAILING:10\
    SLIDINGWINDOW:4:20 MINLEN:36
