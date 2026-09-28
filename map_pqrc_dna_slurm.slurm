#!/bin/bash
#SBATCH --job-name=pqrc_dna                       # Job name
#SBATCH --output=/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/map_all_pqrc_2/pqrc_dna.out   # Standard output log
#SBATCH --error=/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/map_all_pqrc_2/pqrc_dna.err    # Standard error log
#SBATCH --mail-type=BEGIN,END --mail-user=katie.ko@som.umaryland.edu
#SBATCH --cpus-per-task=12				# Number of CPUs per task
#SBATCH --mem=40G                                        # Memory per node
#SBATCH --array=1-4                       #Number of samples

/local/projects-t3/SerreDLab-3/kko/PQRC_all_dna/map_pqrc_dna_slurm.sh

echo "All mapping to Pv are finished"
