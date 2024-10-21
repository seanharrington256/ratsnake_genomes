#!/bin/bash

#SBATCH --job-name vcf_comb_stats
#SBATCH -A inbreh
#SBATCH -t 3-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e errs_outs/err_out_vcf/err_vcfstats_%A.err
#SBATCH -o errs_outs/err_out_vcf/std_vcfstats_%A.out

#load packages
module load gcc/14.2.0 bcftools/1.20 miniconda3/24.3.0 r/4.4.0

conda activate /project/milksnake/software/vcftools


# combines the pre-filtered and post-filtered vcfs from NC scaffolds
#      gets some statistics about the vcf files
#      then runs `r_vcf_stats_cmdline.R` to make plots.


# number of unfiltered variants - removing this for now
# bcftools view -H full_only100_thin20k.vcf.gz | wc -l #may take some time


# set some paths
PREFILT="/project/getpop/ratsnakes/vcf_allsites_fox/sort__NC_*.vcf.gz"
PREFILTCOMB="/project/getpop/ratsnakes/vcf_allsites_fox/NCscafs_allsites_foxout.vcf.gz"

# POSTFILT="/project/getpop/ratsnakes/vcf_allsites/filt_scafs_vcfs/filtered_sort__NC*.vcf.gz"
# POSTFILTCOMB="/project/getpop/ratsnakes/vcf_allsites/filt_scafs_vcfs/filt_sort_NC_allsites_combined.vcf.gz"
# 
# ### all scaffolds post-filtering, not just NC scafs
# POSTFILTALL="/project/getpop/ratsnakes/vcf_allsites/filt_scafs_vcfs/filtered_sort*.vcf.gz"
# POSTFILTCOMBALL="/project/getpop/ratsnakes/vcf_allsites/filt_scafs_vcfs/filt_sort_allsitesALLSCAF_combined.vcf.gz"



# VCFSTATSDIR="/project/getpop/ratsnakes/rat_stats_vcf"
# 
# ################# COMBINE FILES
# 

# COMBINE PRE-FILTERED
bcftools concat -Oz -o $PREFILTCOMB $PREFILT

# 
# # COMBINE POST-FILTERED
# bcftools concat -Oz -o $POSTFILTCOMBALL $POSTFILT
# 
# 
# # Do same for all scaffolds post-filtering, not just NC ones
# bcftools concat -Oz -o $POSTFILTCOMB $POSTFILTALL
# 
# 
# 
# ############# GET STATS
# 
# # Loop to create vcf stats for each combined file
# 
# 
# 
# for VCFFile in "$PREFILTCOMB" "$POSTFILTCOMB" "POSTFILTCOMBALL"; do
# 
# 	VCF_W_EXT=$(basename "$VCFFile")
# 
# 	VCFNAME="${VCF_W_EXT%.vcf.gz}"
# 	
# 	OUT=${VCFSTATSDIR}${VCFNAME}
# 	mkdir -p $OUT
# 	OUTFILE=vcf_stats_${VCFNAME}
# 	
# 	# index vcf file
# 	bcftools index $VCFFile
# 	
# 	
# 	##calc allele frequency - 
# 	##  had to add --min-alleles 2 here because otherwise when generating all sites vcf get a lot of invariants, which have freq of 1 and don't show up as 2 columns, causes problems trying to summarize in R
# 	vcftools --gzvcf $VCFFile --freq2 --max-alleles 2 --min-alleles 2 --out $OUT/$OUTFILE
# 	##calc mean depth/individual
# 	vcftools --gzvcf $VCFFile --depth --out $OUT/$OUTFILE
# 	
# 	##calc mean depth/site
# 	vcftools --gzvcf $VCFFile --site-mean-depth --out $OUT/$OUTFILE
# 	
# 	##site quality
# 	vcftools --gzvcf $VCFFile --site-quality --out $OUT/$OUTFILE
# 	##proportion of missing/individual
# 	vcftools --gzvcf $VCFFile --missing-indv --out $OUT/$OUTFILE
# 	
# 	##proportion of missing/site
# 	vcftools --gzvcf $VCFFile --missing-site --out $OUT/$OUTFILE
# 	
# 	##calc heterozygosity & inbreeding coef/individual
# 	vcftools --gzvcf $VCFFile --het --out $OUT/$OUTFILE
# 	
# 	
# 	# Use R script to make plots: # the unfiltered files are huge, do it just for filtered outside the loop
# 	# Rscript r_vcf_stats_cmdline.R $OUT $OUTFILE
# done
# 
# 
# ### just plot the post-filtered:
# 
# VCFFile="$POSTFILTCOMB"
# 
# VCF_W_EXT=$(basename "$VCFFile")
# 
# VCFNAME="${VCF_W_EXT%.vcf.gz}"
# 	
# OUT=${VCFSTATSDIR}${VCFNAME}
# OUTFILE=vcf_stats_${VCFNAME}
# 		
# 	
# # Use R script to make plots:
# Rscript r_vcf_stats_cmdline.R $OUT $OUTFILE




