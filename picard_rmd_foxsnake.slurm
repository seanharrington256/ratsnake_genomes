#!/bin/bash

#SBATCH --job-name rmd
#SBATCH -A inbreh
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=48G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_rmd_%A_%a.err
#SBATCH -o errs_outs/std_rmd_%A_%a.out


# Load modules
module load gcc/14.2.0 picard/3.2.0 samtools/1.20

# Set up output directory variable
OUTDIR=/project/getpop/ratsnakes/fox_bwa_out

# Set working dir to where the bam files are:
cd /project/getpop/ratsnakes/fox_bwa_out



sample=pvulp-SR1274_sort.bam

name=$(echo $sample| cut -d '_' -f 1)


#add readgroups
picard AddOrReplaceReadGroups \
    I=$sample \
    O=$OUTDIR/${name}.rg.bam \
    RGID=id \
    RGLB=lib1 \
    RGPL=illumina \
    RGPU=unit1 \
    RGSM=$name


#run picard MarkDuplicates
picard \
 MarkDuplicates -REMOVE_DUPLICATES true \
 -ASSUME_SORTED true -VALIDATION_STRINGENCY SILENT \
 -INPUT $OUTDIR/${name}.rg.bam \
 -OUTPUT $OUTDIR/${name}.rmd.bam \
 -METRICS_FILE $OUTDIR/${name}.rmd.bam.metrics


samtools index $OUTDIR/${name}.rmd.bam



