#!/bin/bash

# Paths and settings
WORKING_DIR="/path/to/working_dir/dna_remove_dup_dir"  # Directory to output BAM files with duplicates removed

# Create necessary directories
mkdir -p "$WORKING_DIR"

# Get the subfolder name from the corresponding line in "slurm_dirList3.txt"
SAMPLE_LINE=$(sed "${SLURM_ARRAY_TASK_ID}q;d" /path/to/all_bams_to_remove_dups.txt)

IFS=$'\t' read  SAMPLE_NAME ORIGINAL_BAM_PATH <<< "$SAMPLE_LINE"

if [ -f $ORIGINAL_BAM_PATH ] ; then

    echo "Processing sample: $SAMPLE_NAME"

    FILTERED_SAM_PATH="${WORKING_DIR}"/"${SAMPLE_NAME}_filtered.sam"
    READ_STATS_PATH="${WORKING_DIR}"/"${SAMPLE_NAME}_stats.txt"

    /usr/local/packages/samtools-1.9/bin/samtools view -H $ORIGINAL_BAM_PATH > $FILTERED_SAM_PATH

    /usr/local/packages/samtools-1.9/bin/samtools view -F 4 $ORIGINAL_BAM_PATH | python3 /path/to/dna_remove_dups.py $FILTERED_SAM_PATH $READ_STATS_PATH $SAMPLE_NAME

    # Convert SAM to BAM and sort and index
    FILTERED_BAM_PATH="${WORKING_DIR}"/"${SAMPLE_NAME}_filtered.sorted.bam"
    FILTERED_BAI_PATH="${WORKING_DIR}"/"${SAMPLE_NAME}_filtered.sorted.bai"

    /path/to/samtools-1.9/bin/samtools sort $FILTERED_SAM_PATH -o $FILTERED_BAM_PATH
    /path/to/samtools-1.9/bin/samtools index $FILTERED_BAM_PATH $FILTERED_BAI_PATH

    # Remove intermediate sam file
    rm $FILTERED_SAM_PATH

    # Run mpileup and get number of positions with coverage >= 50x
    MPILEUP_PATH="${WORKING_DIR}"/"${SAMPLE_NAME}.mpileup"

    /path/to/samtools-1.9/bin/samtools mpileup $FILTERED_BAM_PATH -o $MPILEUP_PATH
    awk -F'\t' '$4 >= 50 { count++ } END { print count }' $MPILEUP_PATH >> $READ_STATS_PATH

    echo "Processing completed for $SAMPLE_NAME."

 else
    echo "Paths for $SAMPLE_NAME do not exist."
    exit 1
fi

echo "All processes completed. Aligned files saved in $ALIGN_OUTPUT_DIR."
