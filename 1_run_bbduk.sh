#!/bin/bash

# This script performs the four BBDuk preprocessing steps
# 1. Removal of 151st base
# 2. Adapter trimming
# 3. PhiX removal
# 4. Quality trimming

# Run the script in a loop to submit one job per sample
# for forward in *R1_001.fastq.gz; do sbatch run_bbduk.sh $forward <output directory>; done

forward=$1
output_dir=$2
reverse=${forward/R1/R2}
base="$(basename -- $forward | sed 's/_.*//')"

## 1. Remove last base of 151 bp reads, if there

# Force trim right (ftr) counts bases from 0; so 149 is base 150 and works as 'maximum length'
# I name these "lbt" for "last base trimmed" (intermediate files that will be removed later)
bbduk.sh -Xmx10g in1=$forward in2=$reverse out1=$output_dir/"$base"_lbt_1.fq.gz out2=$output_dir/"$base"_lbt_2.fq.gz ftr=149 t=12

## 2. Adapter trimming

bbduk.sh -Xmx10g in1=$output_dir/"$base"_lbt_1.fq.gz in2=$output_dir/"$base"_lbt_2.fq.gz out1=$output_dir/"$base"_atrim_1.fq.gz out2=$output_dir/"$base"_atrim_2.fq.gz ref=~/bin/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 stats=$output_dir/"$base"_atrim_stats.txt tpe tbo t=12

## 3. PhiX removal

bbduk.sh -Xmx10g in1=$output_dir/"$base"_atrim_1.fq.gz in2=$output_dir/"$base"_atrim_2.fq.gz out1=$output_dir/"$base"_phix_1.fq.gz out2=$output_dir/"$base"_phix_2.fq.gz ref=~/bin/bbmap/resources/phix174_ill.ref.fa.gz k=31 hdist=1 stats=$output_dir/"$base"_phix_stats.txt t=12

## 4. Quality trimming

bbduk.sh -Xmx10g in1=$output_dir/"$base"_phix_1.fq.gz in2=$output_dir/"$base"_phix_2.fq.gz out1=$output_dir/"$base"_processed_1.fq.gz out2=$output_dir/"$base"_processed_2.fq.gz qtrim=r trimq=15 minlength=50 t=12 stats=$output_dir/"$base"_qtrim_stats.txt

# Remove intermediate files
rm $output_dir/"$base"_lbt*.fq.gz
rm $output_dir/"$base"_atrim*.fq.gz
rm $output_dir/"$base"_phix*.fq.gz
