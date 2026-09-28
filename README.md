# pv_relapse
Code used for evaluating Identity by Descent between monoclonal samples analysed in manuscript: _Plasmodium vivax_ relapses are frequent, genetically diverse, and transmissible in Cambodia

Code developed using: [Hisat2 version 2.2.1](https://daehwankimlab.github.io/hisat2/download/), [gatk version 4.2.2.0](https://github.com/broadinstitute/gatk/releases), [samtools version 1.9](https://www.htslib.org/download/), [picard version 2.9.4](https://broadinstitute.github.io/picard/), [vcftools version 0.1.15](https://sourceforge.net/projects/vcftools/), [slurm version 23.11.6](https://slurm.schedmd.com/), [hmmibd-rs version 0.1.5](https://github.com/bguo068/hmmibd-rs), [MEGA11](https://www.megasoftware.net/) 

## Map Illumina WGS paired-end sequencing reads of patient samples using Hisat2
_Map WGS data using Hisat2 and remove PCR duplicates_
-map_pqrc_dna.sh, map_pqrc_dna.slurm: Scripts to run Hisat2 on WGS samples using SLURM workflow manager to run in parallel 
-dna_remove_dups.sh, dna_remove_dups.slurm, dna_remove_dups.py: Scripts to remove PCR duplicates from bam files generated from Hisat2

**Perform analysis**  
- Make hisat2 reference index
```
hisat2-build PlasmoDB-67_PvivaxP01_Genome.fasta PvivaxP01_hisat_index
```
- Run mapping using map_pqrc_dna scripts
  - Change "/path/to/working_dir/" text in map_pqrc_dna.sh and map_pqrc_dna.slurm files into path to desired working directory
  - Change line 8 of map_pqrc_dna.slurm file to reflect number of samples to be processed
  - Create all_sample_paths.txt file, a tab-delimited file where each line has the sample name, path to R1 file, and path to R2 file
'''
sbatch --mem=42G -c 14 map_pqrc_dna.slurm
'''

- Run pcr duplicate removal on bam files generated from Hisat2 using dna_remove_dups scripts
  - Change "/path/to/working_dir/" text in dna_remove_dups.sh and dna_remove_dups.slurm files into path to desired working directory
  - Change line 8 of dna_remove_dups.slurm file to reflect number of samples to be processed
  - Create all_bams_to_remove_dups.txt file, a tab-delimited file where each line has sample name and path to bam file genereated by Hisat2
'''
sbatch --mem=34G -c 14 dna_remove_dups.slurm
'''

## Identity by Descent Analysis
_Prepare a distance matrix for MEGA11 containing identity by descent comparisons for samples_
-vcf_to_hmmibd_input.py: Convert vcf file to matrix format used by hmmibd-rs
-make_fract_sites_ibd_matrix.py: Convert output from hmmibd-rs to matrix format used by MEGA11

**Perform analysis**
- Perform variant calling using GATK and vcftools as previously described in the "GATK Analysis" section [here](https://github.com/ko-katie/pvmdr1) to generate a combined vcf file containing variants shared in at least 80% of samples
- Run vcf_to_hmmibd_input.py to convert the combined vcf file into a matrix inputted into hmmibd-rs
```
python3 vcf_to_hmmibd_input.py /path/to/combined_vcf_file.vcf /path/to/hmmibd_input.txt
```
- Run hmmibd-rs
```
hmmibd-rs -i /path/to/hmmibd_input.txt -o /path/to/hmmibd_output
```
- Run make_fract_sites_ibd_matrix.py to make MEGA11 distance matrix from fract_sites_IBD column of hmmibd-rs output
```
python3 make_fract_sites_ibd_matrix.py /path/to/hmmibd_output.hmm_fract.txt /path/to/distance_matrix_output.meg
```
- Input /path/to/distance_matrix_output.meg into MEGA11 to create Neighbor-Joining tree
