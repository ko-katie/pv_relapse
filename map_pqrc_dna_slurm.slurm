#!/bin/bash
#SBATCH --job-name=pqrc_dna                       # Job name
#SBATCH --output=/path/to/working_dir/pqrc_dna.out   # Standard output log
#SBATCH --error=/path/to/working_dir/pqrc_dna.err    # Standard error log
#SBATCH --mail-type=BEGIN,END --mail-user=katie.ko@som.umaryland.edu
#SBATCH --cpus-per-task=12				# Number of CPUs per task
#SBATCH --mem=40G                                        # Memory per node
#SBATCH --array=1-X                       #Change X to number of samples

/path/to/map_pqrc_dna_slurm.sh

echo "All mapping to Pv are finished"
