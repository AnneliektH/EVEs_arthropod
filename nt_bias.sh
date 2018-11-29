# Jared Nigg, 2018

# !/bin/bash
species=$1

# Executes nucleotide_bias.py, clean_bias_data.py, compare_pos_neg.py, 1U_bais_names.py, and necessary bash commands

# Prior to running this script, you should organize files into '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/fastq' and '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/fastq'. These directories should contain fastq files containing 24-32 nt sRNAs mapping to the positive or negative strand of each EVE, respectively. One file per EVE. 

# Obtain quality statistics for the positive files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/'

mkdir './quality_stats'

mkdir './csv_files/'

cd './fastq/'

for f in *.fastq; do fastx_quality_stats -i $f -o '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats/'${f%%.*}'.txt'; done

# Run nucleotide_bias.py on the positive files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats'

for t in *.txt; do python '/path_to_scripts/nucleotide_bias.py' $t '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats/csv_files/'${t%%.*}'.csv'; done

# Concatenate all the positive nucleotide bias files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats/csv_files/'

cat *.csv > '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/total_nucl_bias.csv'

# Run clean_bias_data.py on the positive total_nucl_bias.csv file
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/'

python '/path_to_scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

# Make total csv with file names file for positive files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats/csv_files/'

grep "" *.csv > '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/quality_stats/csv_files/total_csv_with_filenames.csv'

# Run compare_pos_neg.py to calculate binomial values and give 1T and 10A bias
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/'

python '/path_to_scripts/compare_pos_neg.py' 'base_directory/'$1'/piRNA_length_range_sRNAs/positive/total_csv_with_filenames.csv' 'T_bias_pos.csv' 'A_bias_pos.csv'

#Repeat the same process for the negative strand files
cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/'

mkdir './quality_stats'

mkdir './csv_files/'

cd './fastq/'

for f in *.fastq; do fastx_quality_stats -i $f -o '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats/'${f%%.*}'.txt'; done

cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats'

for t in *.txt; do python '/path_to_scripts/nucleotide_bias.py' $t '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats/csv_files/'${t%%.*}'.csv'; done

cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats/csv_files/'

cat *.csv > '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/total_nucl_bias.csv'

cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/'

python '/path_to_scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats/csv_files/'

grep "" *.csv > '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/quality_stats/csv_files/total_csv_with_filenames.csv'

cd '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/'

python '/path_to_scripts/compare_pos_neg.py' 'base_directory/'$1'/piRNA_length_range_sRNAs/negative/total_csv_with_filenames.csv' 'T_bias_neg.csv' 'A_bias_neg.csv'

# Print the 1U biases to a file
python '/path_to_scripts/1U_bias_names.py' '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/T_bias_pos.csv' '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/T_bias_neg.csv' '/base_directory/'$1'/piRNA_length_range_sRNAs/positive/primary_secondary_counts.csv' '/base_directory/'$1'/piRNA_length_range_sRNAs/negative/primary_secondary_counts.csv' > '/path_to_desired_output/'$1'.csv'
