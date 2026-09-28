#!/bin/bash

# Paths and settings
HISAT2_INDEX="/path/to/PvivaxP01_Index"  # Replace with your HISAT2 index base name
ALIGN_OUTPUT_DIR="/path/to/working_dir"  # Directory for aligned BAM files
SUM_DIR="/path/to/working_dir/sum_dir"
LOG_DIR="/path/to/working_dir/log_dir"
THREADS=32  # Number of threads for HISAT2

# Create necessary directories
mkdir -p "$ALIGN_OUTPUT_DIR"
mkdir -p "$SUM_DIR"
mkdir -p "$LOG_DIR"

# Get the subfolder name from the corresponding line in "slurm_dirList3.txt"
SAMPLE_LINE=$(sed "${SLURM_ARRAY_TASK_ID}q;d" /path/to/all_pqrc_paths.txt)

IFS=$'\t' read  SAMPLE_NAME R1_PATH R2_PATH <<< "$SAMPLE_LINE"

CLEANED_R1_PATH=$(sed -e 's/^"//' -e 's/"$//' <<< "$R1_PATH")
CLEANED_R2_PATH=$(sed -e 's/^"//' -e 's/"$//' <<< "$R2_PATH")

echo "Processing sample: $SAMPLE_NAME"

/path/to/hisat2-2.2.1/hisat2 -x "$HISAT2_INDEX" \
                                        -1 "$CLEANED_R1_PATH" \
                                        -2 "$CLEANED_R2_PATH" \
                                        -S "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sam" \
                                        --max-intronlen 20 \
                                        -p "$THREADS" \
                                        --summary-file "$SUM_DIR/${BSAMPLE_NAME}_summary.txt" \
                                        --new-summary \
                                        2> "$LOG_DIR/${SAMPLE_NAME}.txt"

echo "Mapping completed for $BSAMPLE_NAME. Converting SAM to BAM..."

# Convert SAM to BAM and sort and index
/path/to/samtools-1.9/bin/samtools sort "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sam" -o "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sorted.bam"
/path/to/samtools-1.9/bin/samtools index "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sorted.bam" "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sorted.bai"

# Remove intermediate SAM
rm "$ALIGN_OUTPUT_DIR/${SAMPLE_NAME}.sam"

echo "Processing completed for $SAMPLE_NAME."


echo "All processes completed. Aligned files saved in $ALIGN_OUTPUT_DIR."
