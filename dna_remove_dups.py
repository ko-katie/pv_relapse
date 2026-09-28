# !/usr/bin/env python

import sys,os

#make string to define unique read
def make_unique_read_str(chromosome, startpos, map_next_read_pos):

    return chromosome + "_" + str(startpos) + "_" + str(map_next_read_pos)

bam_file = sys.stdin
filtered_sam_path = sys.argv[1]
read_stats_path = sys.argv[2]
sample_name = sys.argv[3]

filtered_sam_file = open(filtered_sam_path, "a")

unique_reads_dict = {}

mapped_reads_count = 0
duplicated_reads_count = 0

for line in bam_file:

    split_line = line.split("\t")

    mapped_reads_count += 1

    #get read mapping information
    chromosome = split_line[2]
    map_start_pos = int(split_line[3])
    map_next_read_pos = int(split_line[7])

    unique_read_str = make_unique_read_str(chromosome, map_start_pos, map_next_read_pos)

    #if read is not already in unique_reads_dict, add to dictionary and add to coverage
    if unique_read_str not in unique_reads_dict:

        unique_reads_dict[unique_read_str] = 1
        filtered_sam_file.write(line)

    else:

        duplicated_reads_count += 1

filtered_sam_file.close()

read_stats_file = open(read_stats_path, "w")

read_stats_file.write(sample_name + "\t" + str(mapped_reads_count) + "\t" + str(duplicated_reads_count) + "\t")

read_stats_file.close()