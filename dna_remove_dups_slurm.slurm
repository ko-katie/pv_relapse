#!/bin/bash
#SBATCH --job-name=remove_dups                      # Job name
#SBATCH --output=/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/dna_remove_dup_dir/remove_dups.out   # Standard output log
#SBATCH --error=/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/dna_remove_dup_dir/remove_dups.err   # Standard error log
#SBATCH --mail-type=BEGIN,END --mail-user=katie.ko@som.umaryland.edu
#SBATCH --cpus-per-task=12				# Number of CPUs per task
#SBATCH --mem=32G                                        # Memory per node
#SBATCH --array=1-269

/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/dna_remove_dups_slurm.sh

echo "All bams have been processed"
