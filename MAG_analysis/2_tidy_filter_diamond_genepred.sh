#!/bin/bash

# This script filters DIAMOND hits files from a DIAMOND blastp search (prodigal > DIAMOND)
# It expects one file per bin or contig set
# First, it creates a filtered file that removes anything below 80% query/subject coverage
# Then it uses the main file to create individual filtered files for the different percentage identity levels
# These are combined at the end (across all bins too) into a single summary file 

### 1. Keep only hits that have at least 80% query coverage OR 80% subject coverage
for file in *master.txt
do
awk -F '\t' '$11 >= 80 || $12 >= 80 {print $0}' $file > ${file/master/covfilt}
done

### 2. Filter by percentage identity, with different thresholds for certain genes (the MAG threshold, which may be different than the threshold used for short reads)
# Saves each set of genes in a new file, then combines these at the end

# RHO stays at 30%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^RHO-/' $file > "${file/30_hits_covfilt/30_genes}"
done

# Cyc2 to 35%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^Cyc2-/' $file | \
awk -F '\t' '{if ($3 >= 35) print $0}' > "${file/30_hits_covfilt/35_genes}"
done

# RdhA to 45
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^RdhA-/' $file | \
awk -F '\t' '{if ($3 >= 45) print $0}' > "${file/30_hits_covfilt/45_genes}"
done

# CooS, Fe, PmoA, McrA, FCC, Sqr, SoxB, DsrA, AsrA, Sor, HzsA, NifH, NarG, NapA, NrfA, NirS, NirK, NorB, NosZ, AclB, AcsB, HbsC, Mcr, CcoN, CoxA, CydA, CyoA, SdhA-FrdA, ArsC, MtrB, OmcB and FdhA to 50%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^CooS-/ || $2 ~ /^Fe-/ || $2 ~ /^PmoA-/ || $2 ~ /^McrA-/ || \
$2 ~ /^FCC-/ || $2 ~ /^Sqr-/ || $2 ~ /^SoxB-/ || $2 ~ /^DsrA-/ || $2 ~ /^AsrA-/ || $2 ~ /^Sor-/ || \
$2 ~ /^HzsA-/ || $2 ~ /^NifH-/ || $2 ~ /^NarG-/ || $2 ~ /^NapA-/ || $2 ~ /^NrfA-/ || $2 ~ /^NirS-/ || $2 ~ /^NirK-/ || $2 ~ /^NorB-/ || $2 ~ /^NosZ-/ || \
$2 ~ /^AclB-/ || $2 ~ /^AcsB-/ || $2 ~ /^HbsC-/ || $2 ~ /^Mcr-/ || \
$2 ~ /^CcoN-/ || $2 ~ /^CoxA-/ || $2 ~ /^CydA-/ || $2 ~ /^CyoA-/ || $2 ~ /^SdhA_FrdA-/ || \
$2 ~ /^ArsC-/ || $2 ~ /^MtrB-/ || $2 ~ /^OmcB-/ || $2 ~ /^FdhA-/' $file | \
awk -F '\t' '{if ($3 >= 50) print $0}' > "${file/30_hits_covfilt/50_genes}"
done

# CoxL, FeFe, MmoA, AmoA, NxrA, RbcL, AtpA, NuoF and PsbA to 60%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^CoxL-/ || $2 ~ /^FeFe-/ || $2 ~ /^MmoA-/ || $2 ~ /^AmoA-/ || $2 ~ /^NxrA-/ || $2 ~ /^RbcL-/ || $2 ~ /^AtpA-/ || $2 ~ /^NuoF-/ || $2 ~ /^PsbA-/' $file | \
awk -F '\t' '{if ($3 >= 60) print $0}' > "${file/30_hits_covfilt/60_genes}"
done

# NiFe Group 4 to 60%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^NiFe-/' $file | \
awk -F '\t' '{if (!/Group\ 4/) print $0; else if ($3 >= 60) print $0}' > "${file/30_hits_covfilt/60_G4_genes}"
done

# HbsT to 65%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^HbsT-/' $file | \
awk -F '\t' '{if ($3 >= 65) print $0}' > "${file/30_hits_covfilt/65_genes}"
done

# IsoA, YgfK and ARO to 70%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^IsoA-/ || $2 ~ /^YgfK-/ || $2 ~ /^ARO-/' $file | \
awk -F '\t' '{if ($3 >= 70) print $0}' > "${file/30_hits_covfilt/70_genes}"
done

# PsaA to 80%
for file in *covfilt.txt
do
awk -F '\t' '$2 ~ /^PsaA-/' $file | \
awk -F '\t' '{if ($3 >= 80) print $0}' > "${file/30_hits_covfilt/80_genes}"
done

# Move the unfiltered files to a separate directory
mkdir unfiltered
mv *master.txt unfiltered
mv *covfilt.txt unfiltered

# Concatenate all filtered for the dataset
for file in *genes.txt
do
awk '{print $0,"\t",FILENAME}' $file >> all_genes_annotated.txt
done

# Remove the intermediate files
rm *genes.txt
