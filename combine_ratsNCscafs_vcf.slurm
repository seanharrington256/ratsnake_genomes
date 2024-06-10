#!/bin/bash

#SBATCH --job-name combinevcfs
#SBATCH -A inbreh
#SBATCH -t 0-15:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_combinevcfs_%A.err
#SBATCH -o errs_outs/std_combinevcfs_%A.out


#load packages
module load gcc/12.2.0 bcftools/1.16

#move to directory 
cd /project/getpop/ratsnakes/rat_vcf/filt_scafs_vcfs


# combine
bcftools concat -Oz -o filt_ratsNCscafs.vcf.gz filtered_sort_ratsnakes_NC*.vcf.gz

