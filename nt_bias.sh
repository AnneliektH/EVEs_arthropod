# !/bin/bash
species=$1

# Filter the sense fastq files for individual EVEs based on the piRNA length range
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq'

rm -r 'piRNA_length_range'
mkdir './piRNA_length_range'

for f in *.fastq; do awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 24 && length(seq) <= 32) {print header, seq, qheader, qseq}}' < $f > './piRNA_length_range/'${f%%.*}'.fastq'; done

# Filter the Antiense fastq files for individual EVEs based on the piRNA length range
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq'

rm -r 'piRNA_length_range'
mkdir './piRNA_length_range'

for f in *.fastq; do awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 24 && length(seq) <= 32) {print header, seq, qheader, qseq}}' < $f > './piRNA_length_range/'${f%%.*}'.fastq'; done

#Make the necessary folders for sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range'

mkdir './csv_files'

mkdir './fq_files'

mkdir './txt_files'

# Do whatever this does
find -maxdepth 1 -type f -print0 | xargs -0 mv -t './fq_files'

# Do the same for Antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range'

mkdir './csv_files'

mkdir './fq_files'

mkdir './txt_files'

find -maxdepth 1 -type f -print0 | xargs -0 mv -t './fq_files'

# Obtain quality statistics for the sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/fq_files'

for f in *.fastq; do fastx_quality_stats -i $f -o '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/txt_files/'${f%%.*}'.txt'; done

# Obtain quality statistics for the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/fq_files'

for f in *.fastq; do fastx_quality_stats -i $f -o '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/txt_files/'${f%%.*}'.txt'; done

# Run Anneliek's nucleotide_bias.py script on the sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/txt_files'

for t in *.txt; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/nucleotide_bias.py' $t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/'${t%%.*}'.csv'; done

# Run Anneliek's nucleotide_bias.py script on the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/txt_files'

for t in *.txt; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/nucleotide_bias.py' $t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/'${t%%.*}'.csv'; done

# Concatenate all the sense nucleotide bias files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/total_nucl_bias.csv'

# Concatenate all the antisense nucleotide bias files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/total_nucl_bias.csv'

# Run Anneliek's clean_bias_data.py script on the sense total_nucl_bias.csv file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

# Run Anneliek's clean_bias_data.py script on the antisense total_nucl_bias.csv file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

# Do the same thing for EVEs outside piRNA clusters

# Filter the sense fastq files for individual EVEs based on the piRNA length range
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq'

rm -r 'piRNA_length_range'
mkdir './piRNA_length_range'

for f in *.fastq; do awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 24 && length(seq) <= 32) {print header, seq, qheader, qseq}}' < $f > './piRNA_length_range/'${f%%.*}'.fastq'; done

# Filter the Antiense fastq files for individual EVEs based on the piRNA length range
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq'

rm -r 'piRNA_length_range'
mkdir './piRNA_length_range'

for f in *.fastq; do awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 24 && length(seq) <= 32) {print header, seq, qheader, qseq}}' < $f > './piRNA_length_range/'${f%%.*}'.fastq'; done

#Make the necessary folders for sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range'

mkdir './csv_files'

mkdir './fq_files'

mkdir './txt_files'

# Do whatever this does
find -maxdepth 1 -type f -print0 | xargs -0 mv -t './fq_files'

# Do the same for Antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range'

mkdir './csv_files'

mkdir './fq_files'

mkdir './txt_files'

find -maxdepth 1 -type f -print0 | xargs -0 mv -t './fq_files'

# Obtain quality statistics for the sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/fq_files'

for f in *.fastq; do fastx_quality_stats -i $f -o '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/txt_files/'${f%%.*}'.txt'; done

# Obtain quality statistics for the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/fq_files'

for f in *.fastq; do fastx_quality_stats -i $f -o '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/txt_files/'${f%%.*}'.txt'; done

# Run Anneliek's nucleotide_bias.py script on the sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/txt_files'

for t in *.txt; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/nucleotide_bias.py' $t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/'${t%%.*}'.csv'; done

# Run Anneliek's nucleotide_bias.py script on the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/txt_files'

for t in *.txt; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/nucleotide_bias.py' $t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/'${t%%.*}'.csv'; done

# Concatenate all the sense nucleotide bias files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/total_nucl_bias.csv'

# Concatenate all the antisense nucleotide bias files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/total_nucl_bias.csv'

# Run Anneliek's clean_bias_data.py script on the sense total_nucl_bias.csv file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

# Run Anneliek's clean_bias_data.py script on the antisense total_nucl_bias.csv file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/clean_bias_data.py' 'total_nucl_bias.csv' 'binominal_test.csv' 'primary_secondary_counts.csv'

# Make total csv with file names file for sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files'

grep "" *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv'

# Run compare_sense_antisense.py to calculate binomial values and give 1T and 10A bias
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/compare_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv' 'T_bias_sense.csv' 'A_bias_sense.csv'

# Do the same thing for the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files'

grep "" *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/compare_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv' 'T_bias_antisense.csv' 'A_bias_antisense.csv'

# Print the 1U biases to a file
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/1U_bias_names.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/T_bias_sense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/T_bias_antisense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/primary_secondary_counts.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/primary_secondary_counts.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Nucleotide_biases/in_clusters/'$1'.csv'

# Do the same thing for EVEs outside piRNA clusters
# Make total csv with file names file for sense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files'

grep "" *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv'

# Run compare_sense_antisense.py to calculate binomial values and give 1T and 10A bias
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/compare_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv' 'T_bias_sense.csv' 'A_bias_sense.csv'

# Do the same thing for the antisense files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files'

grep "" *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/compare_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/csv_files/total_csv_with_filenames.csv' 'T_bias_antisense.csv' 'A_bias_antisense.csv'

# Print the 1U biases to a file
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/1U_bias_names.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/T_bias_sense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/T_bias_antisense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/primary_secondary_counts.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/primary_secondary_counts.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Nucleotide_biases/out_clusters/'$1'.csv'
