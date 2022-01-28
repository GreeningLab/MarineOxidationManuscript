#!/bin/bash

# I count only the hits over bitscore 40 (genuine hits, threshold previously determined) and I summarise these hits
for file in *hits_L40.txt
do
cat $file | awk -F '\t' '{if ($10 >=40) print $2}' | sort | uniq -c | sort -rn > "${file/.txt/_summary.txt}"
done

# Concatenate all summary files for a dataset
for file in *summary.txt
do
awk '{print $0,"\t",FILENAME}' $file >> all_ribo_hits.txt
done

# Remove the spaces at the beginning of the line, and then replace the first space with a tab (between the counts and the header)
sed -i 's/^ *//; s/ /\t/' all_ribo_hits.txt
