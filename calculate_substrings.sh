# !/bin/bash

# Navigate to the species folder and setup a loop to run the script for all the species
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do echo $D

# Navigate to the folder containing only the alignments column from the BLASTn results of eves in_cluster against the all virus nt database. This folder contains BLASTn results that have been filtered based on query coverage > 39.9. For all results move down two directories. 
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/nt_BLAST_results/good_qcov/alignments'

mkdir './substrings/'

# Run Fokke's script to calculate the value of every substring containing at most two mismatches. Valid substrings can have up to two terminal gaps where the missing nucleotide is present in the query and no gaps where the missing nucleotide is present in the subject. Gaps cannot occur in the middle of a substring. 
for c in *.csv; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/calculate_string_value3.py' $c > './substrings/'$c; done

# Extract just the numerical values for the substrings
cd './substrings/'

for c in *.csv; do sed -i 's/)//g' $c; done

mkdir './substring_values/'

for c in *.csv; do cut -d, -f2 $c > './substring_values/'$c; done

# Print the highest value in each file to a new file.
cd './substring_values/'

mkdir './highest_values/'

for c in *.csv; do grep -Eo '[0-9]+' $c | sort -rn | head -n 1 > './highest_values/'$c; done

# Concatenate the results to a new file
cd './highest_values/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/longest_substring/in_clusters/'$D''

 Navigate to the folder containing only the alignments column from the BLASTn results of eves in_cluster against the all virus nt database. This folder contains BLASTn results that have been filtered based on query coverage > 39.9. For all results move down two directories. 
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/nt_BLAST_results/good_qcov/alignments'

mkdir './substrings/'

# Run Fokke's script to calculate the value of every substring containing at most two mismatches. Valid substrings can have up to two terminal gaps where the missing nucleotide is present in the query and no gaps where the missing nucleotide is present in the subject. Gaps cannot occur in the middle of a substring. 
for c in *.csv; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/calculate_string_value3.py' $c > './substrings/'$c; done

# Extract just the numerical values for the substrings
cd './substrings/'

for c in *.csv; do sed -i 's/)//g' $c; done

mkdir './substring_values/'

for c in *.csv; do cut -d, -f2 $c > './substring_values/'$c; done

# Print the highest value in each file to a new file.
cd './substring_values/'

mkdir './highest_values/'

for c in *.csv; do grep -Eo '[0-9]+' $c | sort -rn | head -n 1 > './highest_values/'$c; done

# Concatenate the results to a new file
cd './highest_values/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/longest_substring/out_clusters/'$D''

# Close the loop
done








