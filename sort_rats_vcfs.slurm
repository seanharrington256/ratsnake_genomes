#!/bin/bash

#SBATCH --job-name sort_vcfs_rats
#SBATCH -A inbreh
#SBATCH -t 0-30:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_sort_rats_vcfs_%A_%a.err
#SBATCH -o errs_outs/std_sort_rats_vcfs_%A_%a.out
#SBATCH --array=1-199

#load packages
module load gcc/12.2.0 bcftools/1.16

cd /project/getpop/ratsnakes/rat_vcf # set directory

#Array
for x in ratsnakes_*.vcf.gz
do
	files=(${files[@]} "${x}")
done

vcf=${files[($SLURM_ARRAY_TASK_ID-1)]} # define the vcf file to work on

echo "started slurm job $SLURM_ARRAY_TASK_ID file $vcf"

# run sort
bcftools sort -Oz $vcf -o sort_$vcf

echo "completed slurm job $SLURM_ARRAY_TASK_ID file $vcf"

# delete the original vcf, we don't need it anymore - removed this to make sure everything completes successfully first
# rm $vcf

