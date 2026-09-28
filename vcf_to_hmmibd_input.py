# !/usr/bin/env python

import sys

vcf_file_path = sys.argv[1]
hmmibd_input_path = sys.argv[2]

vcf_file = open(vcf_file_path, "r")
hmmibd_input = open(hmmibd_input_path, "w")

for line in vcf_file:

    if line[:2] != "##":

        split_line = line.strip().split("\t")

        #write header line with sample names
        if line[0] == "#":

            hmmibd_input.write("CHROM\tPOS\t")
            
            samples = split_line[9:]
            hmmibd_input.write("\t".join(samples) + "\n")

        #write genotype information
        else:

            chrom_and_pos = split_line[:2]
            chrom_pos_string = "\t".join(chrom_and_pos) + "\t"
            #hmmibd_input.write("\t".join(chrom_and_pos) + "\t")

            genotype_list = []
            non_missing_count = 0

            for sample in split_line[9:]:

                split_sample = sample.split(":")
                depth = split_sample[2]

                if depth != "." and int(depth) >= 30:

                    genotype = split_sample[0]

                    if genotype == ".":

                        genotype_list.append("-1")
                        #hmmibd_input.write("\t" + "-1")
                    
                    else:
                        
                        genotype_list.append(genotype)
                        non_missing_count += 1
                        #hmmibd_input.write("\t" + genotype)

                else:

                    genotype_list.append("-1")
                    #hmmibd_input.write("\t" + "-1")

            proportion_non_missing = non_missing_count / len(genotype_list)

            #only write variant if it can be called in at least 0.8 of samples (previously 0.2)
            if proportion_non_missing >= 0.8:

                hmmibd_input.write(chrom_pos_string + "\t".join(genotype_list) + "\n")                

            #hmmibd_input.write("\n")

vcf_file.close()
hmmibd_input.close()
