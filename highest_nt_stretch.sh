# Jared Nigg, 2018

# !/bin/bash
arthropod_species=$1

# This script calculates the longest identical nucleotide stretch between EVEs and all BLASTn hits with evalue < .001 and query coverage > 39.9%. This script assumes you have a directory containing the nucleotide sequences for each EVE you wish to analyze. One file per EVE

# Navigate to the directory containing the EVE nucleotide sequences

cd '/base_directory/'$1'/individual_EVE_nt_sequences/'

# Make a directory to hold the BLAST results
mkdir './nt_BLAST_results/'

#BLAST the individual EVE nucleotide sequences against the viral nucleotide database
for f in *.fasta; do blastn -query $f -db '/path_to_BLAST_database_of_viral_nucleotide_sequences/db' -evalue .001 -word_size 7 -num_threads 15 -outfmt "6 pident qcovs btop" -parse_deflines -out '/base_directory/'$1'/individual_EVE_nt_sequences/nt_BLAST_results/'${f%%.*}'.csv'; done

# Remove any results with query coverage < 70
cd '/base_directory/'$1'/individual_EVE_nt_sequences/nt_BLAST_results/'

mkdir './good_qcov/'

for c in *.csv; do awk '($2 > 39.9)' $c > './good_qcov/'${c%%.*}'.csv'; done

# Copy the alignment data to a new file 
cd './good_qcov/'

mkdir './alignments/'

for c in *.csv; do cut -f3 $c > './alignments/'${c%%.*}'.csv'; done

# Copy the alignments into a new folder to be used for calculation of the longest perfectly identical stretch
cd './alignments/'

mkdir './longest/'

for c in *.csv; do cp $c './longest/'; done

# Convert letters and gaps to commas
cd './longest/'

for c in *.csv; do sed -i 's/A/,/g' $c; done
for c in *.csv; do sed -i 's/C/,/g' $c; done
for c in *.csv; do sed -i 's/T/,/g' $c; done
for c in *.csv; do sed -i 's/G/,/g' $c; done
for c in *.csv; do sed -i 's/-/,/g' $c; done

# Print the highest value in each file to a new file.
mkdir './highest_number/'

for c in *.csv; do grep -Eo '[0-9]+' $c | sort -rn | head -n 1 > './highest_number/'$c; done

# Concatenate the results and save as a new file
cd './highest_number/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/longest_identical/in_clusters/'$D'.csv'

# Do the same thing for EVEs outside piRNA clusters

# Navigate to the directory containing the in clusters base directory
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/'

# Create a directory to hold nucleotide sequences
mkdir './nt_sequences/'

# Navigate to the individual EVE bed file directory
cd './bed_files/individual_EVE_bed_files/'

# Extract the nucleotide sequence corresponding to each bed file
for b in *.bed; do bedtools getfasta -fo '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/nt_sequences/'${b%%.*}'.fasta' -fi '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/'$D'_genome.fasta' -bed $b; done 

# Navigate to the directory containing the in clusters base directory
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/'

# Make a directory to hold the BLAST results
mkdir './nt_BLAST_results/'

#BLAST the individual EVE nucleotide sequences against the viral nucleotide database
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/nt_sequences'

for f in *.fasta; do blastn -query $f -db '/media/falklabuser/LargeData/Anneliek/custom_DB_virus/nt_sequences/all_nt' -evalue .001 -word_size 7 -num_threads 15 -outfmt "6 pident qcovs btop" -parse_deflines -out '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/nt_BLAST_results/'${f%%.*}'.csv'; done

# Remove any results with query coverage < 70
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/nt_BLAST_results'

mkdir './good_qcov/'

for c in *.csv; do awk '($2 > 39.9)' $c > './good_qcov/'${c%%.*}'.csv'; done

# Copy the alignment data to a new file 
cd './good_qcov/'

mkdir './alignments/'

for c in *.csv; do cut -f3 $c > './alignments/'${c%%.*}'.csv'; done

# Copy the alignments into a new folder to be used for calculation of the longest perfectly identical stretch
cd './alignments/'

mkdir './longest/'

for c in *.csv; do cp $c './longest/'; done

# Convert letters and gaps to commas
cd './longest/'

for c in *.csv; do sed -i 's/A/,/g' $c; done
for c in *.csv; do sed -i 's/C/,/g' $c; done
for c in *.csv; do sed -i 's/T/,/g' $c; done
for c in *.csv; do sed -i 's/G/,/g' $c; done
for c in *.csv; do sed -i 's/-/,/g' $c; done

# Print the highest value in each file to a new file.
mkdir './highest_number/'

for c in *.csv; do grep -Eo '[0-9]+' $c | sort -rn | head -n 1 > './highest_number/'$c; done

# Concatenate the results and save as a new file. This will output a file that has one line per EVE that had BLASTn matches fitting the criteria (evalue < .001, query coverage > 39.9%). The number on the line will be the longest perfectly identical stretch between that EVE and all its valid BLASTn matches.
cd './highest_number/'

cat *.csv > '/base_directory/'$1'/longest_nt_stretch.csv'




