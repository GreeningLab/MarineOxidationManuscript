#!/bin/bash

# Use MaxBin2 to bin assemblies (coassemblies)
# It requires the contigs and the contig coverage.
# Because each sample's coverage is passed as a separate argument (-abund, -abund2, etc.) and each coassembly has a different number of samples, this is a project-specific script
# Run it as sbatch maxbin2_binning_coassemblies.sh <contig dir> <coverage dir> <outdir>

contigdir=$1
covdir=$2
outdir=$3

# The full-dataset coassembly
mkdir $outdir/alldata
run_MaxBin.pl -contig $contigdir/alldata.contigs.fa -abund $covdir/SC6753_alldata_coverage_maxbin2.txt \
-abund2 $covdir/SC6754_alldata_coverage_maxbin2.txt \
-abund3 $covdir/SC6755_alldata_coverage_maxbin2.txt \
-abund4 $covdir/SC6756_alldata_coverage_maxbin2.txt \
-abund5 $covdir/SC9736_alldata_coverage_maxbin2.txt \
-abund6 $covdir/SC9737_alldata_coverage_maxbin2.txt \
-abund7 $covdir/SC9738_alldata_coverage_maxbin2.txt \
-abund8 $covdir/SC9739_alldata_coverage_maxbin2.txt \
-abund9 $covdir/SC9740_alldata_coverage_maxbin2.txt \
-abund10 $covdir/SC9741_alldata_coverage_maxbin2.txt \
-abund11 $covdir/SC9742_alldata_coverage_maxbin2.txt \
-abund12 $covdir/SC9743_alldata_coverage_maxbin2.txt \
-abund13 $covdir/SC9744_alldata_coverage_maxbin2.txt \
-abund14 $covdir/SC9745_alldata_coverage_maxbin2.txt \
-out $outdir/alldata/alldata -min_contig_length 2000 -thread 10

rm $outdir/alldata/*.tooshort
rm $outdir/alldata/*.noclass

# The Heron assembly
mkdir $outdir/Heron
run_MaxBin.pl -contig $contigdir/Heron.contigs.fa -abund $covdir/SC9736_Heron_coverage_maxbin2.txt -abund2 $covdir/SC9737_Heron_coverage_maxbin2.txt -out $outdir/Heron/Heron -min_contig_length 2000 -thread 10

rm $outdir/Heron/*.tooshort
rm $outdir/Heron/*.noclass

# The MunidaNeritic assembly
mkdir $outdir/MunidaNeritic
run_MaxBin.pl -contig $contigdir/MunidaNeritic.contigs.fa -abund $covdir/SC9738_MunidaNeritic_coverage_maxbin2.txt -abund2 $covdir/SC9739_MunidaNeritic_coverage_maxbin2.txt -out $outdir/MunidaNeritic/MunidaNeritic -min_contig_length 2000 -thread 10

rm $outdir/MunidaNeritic/*.tooshort
rm $outdir/MunidaNeritic/*.noclass

# The Munida STW assembly
mkdir $outdir/MunidaSTW
run_MaxBin.pl -contig $contigdir/MunidaSTW.contigs.fa -abund $covdir/SC9740_MunidaSTW_coverage_maxbin2.txt -abund2 $covdir/SC9741_MunidaSTW_coverage_maxbin2.txt -out $outdir/MunidaSTW/MunidaSTW -min_contig_length 2000 -thread 10

rm $outdir/MunidaSTW/*.tooshort
rm $outdir/MunidaSTW/*.noclass

# The Munida SAW assembly
mkdir $outdir/MunidaSAW
run_MaxBin.pl -contig $contigdir/MunidaSAW.contigs.fa -abund $covdir/SC9742_MunidaSAW_coverage_maxbin2.txt -abund2 $covdir/SC9743_MunidaSAW_coverage_maxbin2.txt -abund3 $covdir/SC9744_MunidaSAW_coverage_maxbin2.txt -abund4 $covdir/SC9745_MunidaSAW_coverage_maxbin2.txt -out $outdir/MunidaSAW/MunidaSAW -min_contig_length 2000 -thread 10

rm $outdir/MunidaSAW/*.tooshort
rm $outdir/MunidaSAW/*.noclass

# The PPB assembly
mkdir $outdir/PPB
run_MaxBin.pl -contig $contigdir/PPB.contigs.fa -abund $covdir/SC6753_PPB_coverage_maxbin2.txt -abund2 $covdir/SC6754_PPB_coverage_maxbin2.txt -abund3 $covdir/SC6755_PPB_coverage_maxbin2.txt -abund4 $covdir/SC6756_PPB_coverage_maxbin2.txt -out $outdir/PPB/PPB -min_contig_length 2000 -thread 10

rm $outdir/PPB/*.tooshort
rm $outdir/PPB/*.noclass
