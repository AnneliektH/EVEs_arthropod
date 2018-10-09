cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do echo $D

# Navigate to the directory containing the in clusters base directory
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/'

# Create a directory to hold nucleotide sequences
mkdir './nt_sequences/'

# Navigate to the individual EVE bed file directory
cd './bed_files/individual_EVE_bed_files/'

# Extract the nucleotide sequence corresponding to each bed file
for b in *.bed; do bedtools getfasta -fo '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/nt_sequences/'${b%%.*}'.fasta' -fi '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/'$D'_genome.fasta' -bed $b; done 

# Navigate to the directory containing the in clusters base directory
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/'

# Make a directory to hold the BLAST results
mkdir './nt_BLAST_results/'

#BLAST the individual EVE nucleotide sequences against the viral nucleotide database
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/nt_sequences'

for f in *.fasta; do blastn -query $f -db '/media/falklabuser/LargeData/Anneliek/custom_DB_virus/nt_sequences/all_nt' -evalue .001 -word_size 7 -num_threads 15 -outfmt "6 pident qcovs btop" -parse_deflines -out '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/nt_BLAST_results/'${f%%.*}'.csv'; done

# Remove any results with query coverage < 70
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/nt_BLAST_results'

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

# Concatenate the results and save as a new file
cd './highest_number/'

cat *.csv > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/longest_identical/out_clusters/'$D'.csv'

# Concatenate the in_clusters and out_cluster results
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/longest_identical/'

cat './in_clusters/'$D'.csv' './out_clusters/'$D'.csv' > ''$D'.csv' 
done





