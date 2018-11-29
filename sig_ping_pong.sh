# Jared Nigg, 2018

# !/bin/bash
species=$1

# Important: This script uses output files from nt_bias.sh and will not work unless that script has been run

# This script runs merge_pos_neg.py, signature.py (Antoniewski, 2014), extract_for_zscore.py, find_sign_Z10.py, and necessary bash commands to calculate the number of EVEs that have mapped piRNAs with 1U and 10A biases on opposite strands and a significant ping-pong Z-score

# Merge positive 1U bias files with negative 10A bias files and positive 10A bias files with negative 1U bias files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs'

python '/path_to_scripts/merge_pos_neg.py' '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/T_bias_pos.csv' '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/A_bias_neg.csv' 'merged_on_1pos.csv'

python '/path_to_scripts/merge_pos_neg.py' '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/T_bias_neg.csv' '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/A_bias_pos.csv' 'merged_on_1neg.csv'

# Navigate to a directory containing SAM files for each EVE. One file per EVE.

# Navigate to the base folder for the species and make a directory for the output of signature.py (Antoniewski, 2014)
cd '/base_directory/'$1'/individual_EVE_sam_files/'

mkdir './for_z_score'

# Run signature.py (Antoniewski, 2014) on the SAM files
for s in *.sam; do python '/path_to_scripts/signature.py' $s '24' '32' '0' '20' '//base_directory/'$1'/individual_EVE_sam_files/for_z_score/'${s%%.*}'.txt'; done

# Run extract_for_zscore.py script on the output files from merge_pos_neg.py. This determines which EVEs had mapped piRNAs with 1U and 10A biases on opposite strands and outputs the names of corresponding EVE files to $1_for_Z_score.csv
cd '/base_directory/'$1'/piRNA_length_range_sRNAs'

python '/path_to_scripts/extract_for_zscore.py' 'merged_on_1neg.csv' 'merged_on_1pos.csv' ''$1'_for_Z_score.csv'

# Copy the output of signature.py (Antoniewski, 2014) to a new directory called '~/only_secondary/' for files that are specified by $1_for_Z_score.csv
cd '/base_directory/'$1'/individual_EVE_sam_files/'

mkdir './only_secondary'

cd '/base_directory/'$1'/individual_EVE_sam_files/for_z_score/'

xargs -a '/base_directory/'$1'/piRNA_length_range_sRNAs/'$1'_for_Z_score.csv' mv -t '/base_directory/'$1'/individual_EVE_sam_files/only_secondary/'

# Run find_sign_Z10.py to find EVEs with a Z-score above 3.2905, which corresponds to a p-value of .001 given a two-tailed hypothesis. Print the results to a new file, which has the word "significant" for each time there is a significant EVE
cd '/base_directory/'$1'/individual_EVE_sam_files/only_secondary/'

for f in *.txt; do echo $f; '/path_to_scripts/find_sign_Z10.py' $f | tee -a '/base_directory/'$1'/'$1'_significant_ping_pong.txt'; done




