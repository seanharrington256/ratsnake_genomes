# Ratsnake genome mapping

<br>
<br>

## Trimming & QC

1. `fastqc_pre_trim.slurm` runs fastqc on the pre-trimmed reads

2. `fastqc_pre_trim.slurm` runs Trimmomatic on reads

3. `fastqc_pre_trim.slurm` runs fastqc on the trimmed reads

<br>

## Mapping reads

1. `BWA_rats.slurm` maps the reads using BWA

2. `flagstat_rats.slurm` runs samtools flagstat to get some mapping stats

3. `picard_rmd_rats.slurm` runs picard mark duplicates

<br>

## Variant calling - variable sites only

1. `var_cal_rats.slurm` calls variants (excludes invariant sites)

2. `sort_rats_vcfs.slurm` sort each scaffold vcf

3. `filter_vcfs_rats.slurm` filter each scaffold vcf

4. `combine_ratsNCscafs_vcf.slurm` combine vcfs - here using only NC scaffolds

5. `r_vcf_stats_ratsNCscafs.R` R script to get some stats

6. `get_vcf_stats_ratsNCscafs.slurm` get some more stats on vcf


<br>

## Variant calling all sites, include invariants


1. `var_call_allsites.slurm` call variants and invariants

2. `sort_allsites_vcfs.slurm` sort scaffold vcfs

3. `filter_each_vcf_allsites.slurm` filter each 

4. `r_vcf_stats_cmdline.R` R script for stats

5. `Combine_NC_vcf_get_stats_allsites.slurm` makes combined vcfs for allsites, including an unfiltered combined


<br>
<br>
<br>


## Add in fox snake as outgroup

Reads are already trimmed by Jeff Weinell

1. `bwa_foxsnake.slurm` maps to the ratsnake reference genome

2. `flagstat_foxsnake.slurm` runs samtools flagstat to get some mapping stats

3. `picard_rmd_foxsnake.slurm` runs picard mark duplicates

4. `var_call_allsites_fox.slurm` calls variants, including including invariants (all sites vcf) for each scaffold separately



<br>
<br>
<br>

`testing_vcf_filt.txt` has some info about how many variants under different filtering schemes. This was done for a single scaf to reduce time









