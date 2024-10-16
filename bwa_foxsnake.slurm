#!/bin/bash

#SBATCH --job-name BWA_rat
#SBATCH -A inbreh
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=60G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_BWA_rat_%A_%a.err
#SBATCH -o errs_outs/std_BWA_rat_%A_%a.out


# load modules necessary
module load  gcc/14.2.0 samtools/1.20 miniconda3/24.3.0
conda activate /project/milksnake/software/bwa  


# Set working directory to where the trimmed_reads are
cd /project/getpop/ratsnakes/trimmed_fq_foxsnake

# Reference genome path
REF=/project/getpop/ref/ratsnake_genome_files/ratsnake_scaffold/P_alleghaniensis_concatenate_ragtag.scaffolds.fasta


OUT_DIR=/project/getpop/ratsnakes/fox_bwa_out

SAMP_ID=pvulp-SR1274


R1=Pantherophis-vulpinus-SR1274_cleaned-DNA-reads_illumina-PE150_R1.fastq.gz
R2=Pantherophis-vulpinus-SR1274_cleaned-DNA-reads_illumina-PE150_R2.fastq.gz


# Run bwa on using the mem algorithm, then pipe output to samtools to convert to bam and sort the bam file
bwa mem -M -t 24 $REF $R1 $R2 | samtools view - -b | samtools sort - -o $OUT_DIR/${SAMP_ID}_sort.bam


# index the BAM files
samtools index -@ 24 $OUT_DIR/${SAMP_ID}_sort.bam
