# MarineOxidationManuscript
Analysis scripts for the manuscript on oxidation of hydrogen and carbon monoxide by marine microbes

## Pre-processing and data QC
`1_run_bbduk.sh`: Take raw metagenome reads and apply trimming and quality control.
`2_fastqc.sh`: Check raw reads and high quality reads for issues.

## Short-read analysis


## Metagenome assembly and binning
`Assembly_binning/1_megahit.sh`
Use MEGAHIT to coassemble metagenomes. 

`Assembly_binning/2_metaspades.sh`
Use metaSPAdes to individually assemble metagenomes.

Before continuing, I adjust the contig headers to indicate which assembly they came from (otherwise, contig headers may be duplicated across different assemblies).

`Assembly_binning/3a_bbmap_to_coassembly.sh`
`Assembly_binning/3b_bbmap_to_ind_assembly.sh`
Use BBMap to map the reads to the coassembly, and to the individual assemblies, to generate coverage profiles.

`Assembly_binning/4aa_metabat2_binning_coassembly.sh`
`Assembly_binning/4ab_metabat2_binning_individual.sh`
Generate bins from assembled contigs using MetaBAT2.

`Assembly_binning/4ba_maxbin2_binning_coassembly.sh`
`Assembly_binning/4bb_maxbin2_binning_individual.sh`
Generate bins from assembled contigs using MaxBin2.

`Assembly_binning/4ca_concoct_binning_coassembly.sh`
`Assembly_binning/4cb_concoct_binning_individual.sh`
Generate bins from assembled contigs using CONCOCT.

`Assembly_binning/5_dastool.sh`
Dereplicate bins from different tools (but the same assembly) with DAS_Tool, to generate one set of bins per assembly.

`Assembly_binning/6_refinem.sh`
Refine bins with RefineM.

`Assembly_binning/7_drep.sh`
Dereplicate bins across the dataset with dRep, to produce one final set of bins.

`Assembly_binning/8_checkm.sh`
Check the quality of bins (completeness, contamination, strain heterogeneity) with CheckM.

`Assembly_binning/9_gtdb-tk.sh`
Assign taxonomy to each bin with GTDB-Tk.

`Assembly_binning/10_coverm.sh`
Calculate genome coverage of each MAG (relative abundance of each MAG in each sample, as well as mean read coverage per bin across the dataset).



