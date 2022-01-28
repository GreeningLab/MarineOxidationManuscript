#!/bin/bash

# Tidy up filenames
for file in *_50_hits.txt
do
new="$(echo $file | sed 's/\^//; s/-//')"
mv $file $new
done

# CoxL, MmoA, AmoA, NxrA, RbcL, NuoF and FeFe hydrogenases to 60%
for file in *_CoxL_50_hits.txt *_MmoA_50_hits.txt *_AmoA_50_hits.txt *_NxrA_50_hits.txt *_RbcL_50_hits.txt *_NuoF_50_hits.txt *_FeFe_50_hits.txt
do
awk -F '\t' '{if ($3 >= 60) print $0}' $file  > "${file/50_hits/60_hits}"
done

# HbsT to 75%
for file in *_HbsT_50_hits.txt
do
awk -F '\t' '{if ($3 >= 75) print $0}' $file  > "${file/50_hits/75_hits}"
done

# PsaA to 80%
for file in *_PsaA_50_hits.txt
do
awk -F '\t' '{if ($3 >= 80) print $0}' $file  > "${file/50_hits/80_hits}"
done

# PsbA, IsoA, AtpA, YgfK and ARO to 70%
for file in *_PsbA_50_hits.txt *_IsoA_50_hits.txt *_AtpA_50_hits.txt *_YgfK_50_hits.txt *_ARO_50_hits.txt
do
awk -F '\t' '{if ($3 >= 70) print $0}' $file  > "${file/50_hits/70_hits}"
done

# Hydrogenases; Group 4 to 60%
for file in *_NiFe_50_hits.txt
do
awk -F '\t' '{if (!/Group\ 4/) print $0; else if ($3 >= 60) print $0}' $file > "${file/_50_/_filtered_}"
done

# Move the unfiltered files to a separate directory
mkdir unfiltered
mv *{CoxL,MmoA,AmoA,NxrA,RbcL,NuoF,FeFe,HbsT,PsaA,PsbA,IsoA,AtpA,YgfK,ARO,NiFe}_50_hits.txt unfiltered

# Then summarise the hits
for file in *hits.txt
do
cat $file | awk -F '\t' '{print $2}' | sort | uniq -c | sort -rn > "${file/.txt/_summary.txt}"
done

# Concatenate all summary files for a dataset
for file in *summary.txt
do
awk '{print $0,"\t",FILENAME}' $file >> all_hits_metaG.txt
done

# Remove the spaces at the beginning of the line, and then replace the first space with a tab (between the counts and the header)
sed -i 's/^ *//; s/ /\t/' all_hits_metaG.txt
