#!/bin/bash

#SBATCH --job-name flagstat
#SBATCH -A inbreh
#SBATCH -t 0-36:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=25G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_flagstat_%A_%a.err
#SBATCH -o errs_outs/std_flagstat_%A_%a.out



# load modules necessary
module load gcc/14.2.0 samtools/1.20

REF=/project/getpop/ref/ratsnake_genome_files/ratsnake_scaffold/P_alleghaniensis_concatenate_ragtag.scaffolds.fasta

OUT_DIR=/project/getpop/ratsnakes/flagstat


# Set working directory to where the sorted reads are

cd /project/getpop/ratsnakes/fox_bwa_out


#run
samtools flagstat -@ 12 pvulp-SR1274_sort.bam > $OUT_DIR/pvulp-SR1274_flagstat.out


