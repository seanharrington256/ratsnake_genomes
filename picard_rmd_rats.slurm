#!/bin/bash

#SBATCH --job-name rmd
#SBATCH -A inbreh
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_rmd_%A_%a.err
#SBATCH -o errs_outs/std_rmd_%A_%a.out
#SBATCH --array 1-32


# Load modules
module load gcc/12.2.0 picard/2.26.2 samtools/1.16.1

# Set up output directory variable
OUTDIR=/project/getpop/ratsnakes/rat_bwa_rmd_out

# Set working dir to where the bam files are:
cd /project/getpop/ratsnakes/rat_bwa_out

#array of files
for x in *.bam
do   
  bams=(${bams[@]} "${x}")
done


# Get the file name of each sample
sample=${bams[($SLURM_ARRAY_TASK_ID-1)]}
# get individual name only from that file name
name=$(echo $sample| cut -d '_' -f 1)

echo "starting slurm job $SLURM_ARRAY_TASK_ID sample $name"

#run picard MarkDuplicates
picard \
 MarkDuplicates REMOVE_DUPLICATES=true \
 ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
 INPUT=$sample \
 OUTPUT=$OUTDIR/${name}.rmd.bam \
 METRICS_FILE=$OUTDIR/${name}.rmd.bam.metrics

echo "indexing slurm job $SLURM_ARRAY_TASK_ID sample $name"

samtools index $OUTDIR/${name}.rmd.bam

echo "completed slurm job $SLURM_ARRAY_TASK_ID sample $name"