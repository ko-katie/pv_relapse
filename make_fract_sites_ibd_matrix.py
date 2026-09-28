# !/usr/bin/env python

import sys

def update_sample_list(sample_list, sample1, sample2):

    if sample1 not in sample_list:

        sample_list.append(sample1)

    if sample2 not in sample_list:

        sample_list.append(sample2)

    return sample_list

def make_pairwise_comparison_string(sample1, sample2):

    compared_samples = [sample1, sample2]
    compared_samples.sort()

    return str(compared_samples[0]) + "_" + str(compared_samples[1])    

hmmibd_output_path = sys.argv[1]
matrix_output_path = sys.argv[2]

hmmibd_output_file = open(hmmibd_output_path, "r")

hmmibd_output_file.readline()

sample_list = []
matrix_dict = {}

#add pairwise fractions from hmmibd output to matrix_dict
for line in hmmibd_output_file:

    split_line = line.strip().split("\t")

    sample1 = split_line[0]
    sample2 = split_line[1]

    sample_list = update_sample_list(sample_list, sample1, sample2)

    fract_sites_ibd = split_line[9]

    pairwise_samples_string = make_pairwise_comparison_string(sample1, sample2)

    matrix_dict[pairwise_samples_string] = fract_sites_ibd

#add same sample comparisons to matrix_dict
for sample in sample_list:

    same_sample_comparison_string = sample + "_" + sample
    matrix_dict[same_sample_comparison_string] = 1

hmmibd_output_file.close()

matrix_output_file = open(matrix_output_path, "w")

##### PRINT SYMMETRICAL MATRIX #####

# write column header of matrix
# matrix_output_file.write("\t" + "\t".join(sample_list) + "\n")

# for row_sample in sample_list:

#     matrix_output_file.write(row_sample + "\t")

#     row_fract_sites_ibds = []

#     for column_sample in sample_list:

#         pairwise_samples_string = make_pairwise_comparison_string(row_sample, column_sample)

#         fract_sites_ibd = matrix_dict[pairwise_samples_string]
#         row_fract_sites_ibds.append(str('{:.12f}'.format(1 - float(fract_sites_ibd))))

#     matrix_output_file.write("\t".join(row_fract_sites_ibds) + "\n")

# matrix_output_file.close()

##### PRINT LOWER-LEFT MEGA11 MATRIX #####

matrix_output_file.write("#MEGA\n!TITLE:IBD distance matrix;\n\n")

for index in range(len(sample_list)):

    curr_sample = sample_list[index]
    matrix_output_file.write("#" + curr_sample + "\n")

matrix_output_file.write("\n")

for second_index in range(len(sample_list)-1):

    second_index += 1
    row_fract_sites_ibds = []

    for first_index in range(0, second_index):

        first_sample_name = sample_list[first_index]
        second_sample_name = sample_list[second_index]

        pairwise_comparison_string = make_pairwise_comparison_string(first_sample_name, second_sample_name)
        fract_sites_ibd = matrix_dict[pairwise_comparison_string]
        row_fract_sites_ibds.append(str('{:.12f}'.format(1 - float(fract_sites_ibd))))

    matrix_output_file.write("\t".join(row_fract_sites_ibds) + "\n")

matrix_output_file.close()
