#!/bin/bash
#SBATCH --job-name=remove_dups                      # Job name
#SBATCH --output=/path/to/working_dir/remove_dups.out   # Standard output log
#SBATCH --error=/path/to/working_dir/remove_dups.err   # Standard error log
#SBATCH --mail-type=BEGIN,END --mail-user=your_email@gmail.com
#SBATCH --cpus-per-task=12				# Number of CPUs per task
#SBATCH --mem=32G                                        # Memory per node
#SBATCH --array=1-X               # Change X to reflect number of samples to be processed

/path/to/working_dir/dna_remove_dups_slurm.sh

echo "All bams have been processed"
