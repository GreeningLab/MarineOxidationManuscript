#!/bin/bash

# Map reads to an assembly with BBMap (coassemblies)
# for forward in <specify forward reads belonging to coassembly>; do bbmap_to_coassembly.sh $forward <specify the contig reference to use>  <output directory>; done

forward=$1
reverse=${forward/_1/_2}
contigs=$2
outputdir=$3
sample="$(basename -- $forward | sed 's/_processed_1.fq.gz//')"
assembly="$(basename -- $contigs | sed 's/.contigs_bbref//')"

cd $outputdir
module load samtools/1.9

bbmap.sh in1=$forward in2=$reverse path=$contigs covstats="$sample"_"$assembly"_coverage.txt out="$sample"_"$assembly"_mapped.sam ambiguous=random threads=15 -Xmx50g statsfile="$sample"_"$assembly"_bbmap.log trimreaddescriptions=t bamscript="$sample"_"$assembly"_bs.sh

sh "$sample"_"$assembly"_bs.sh

rm "$sample"_"$assembly"_mapped.sam
