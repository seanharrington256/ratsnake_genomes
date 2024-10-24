#!/bin/bash

#SBATCH --job-name var_call
#SBATCH -A inbreh
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=30G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_out_vcf/err_varcallAllSite_%A_%a.err
#SBATCH -o errs_outs/err_out_vcf/std__varcallAllSite_%A_%a.out
#SBATCH --array=1-199



# Variant calling all samples at once


#load modules
module load gcc/14.2.0 bcftools/1.20 


## Path to bam files
sorted=/project/getpop/ratsnakes/rat_bwa_rmd_out
foxbam=/project/getpop/ratsnakes/fox_bwa_out/pvulp-SR1274.rmd.bam

#reference
REF=/project/getpop/ref/ratsnake_genome_files/ratsnake_scaffold/P_alleghaniensis_concatenate_ragtag.scaffolds.fasta

## Create some output folders
OUTDIR=/project/getpop/ratsnakes/vcf_allsites_fox/
mkdir -p $OUTDIR


# Get the region of interest from the bed file
scaf=`cat /project/getpop/ref/ratsnake_genome_files/ratsnake_scaffold/P_alleghaniensis_concatenate_ragtag.scaffolds.bed | head -n $SLURM_ARRAY_TASK_ID | tail -n 1 | cut -f 1`

echo "started scaffold $scaf - array num $SLURM_ARRAY_TASK_ID"


# Output path
OUT=${OUTDIR}

# Go to target directory
cd $sorted

#run mpileup
bcftools mpileup --threads 12 -A -a DP,AD --regions $scaf -f $REF *.rmd.bam $foxbam | bcftools call -f GQ,GP -m -Oz -f GQ --threads 12 -o ${OUT}_${scaf}.vcf.gz

echo "completed scaffold $scaf"
