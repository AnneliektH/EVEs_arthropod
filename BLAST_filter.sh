# !/bin/bash
arthropod_species=$1

#Jared Nigg, 2018

# Starts with an intital BLAST output file that has been run through parse_xml.py. Extracts the nucleotide sequence of each EVE based on BLAST coordinates, then does BLASTx of each nucleotide sequence against the Drosophila melanogaster proteome. Removes from the original list any EVEs that had a match in the Drosophila proteome

# Make a directory to hold the new bed files
cd Path to directory containing output of parse_xml.py ('/base_directory/'$1'/'$1'_BLAST_final.csv')

mkdir './bed_files'

# Remove quotes from the EVE list
sed 's/"//g' ''$1'_BLAST_final.csv' > ''$1'_BLAST_final_no_quotes.csv'

# Copy the start and stop columns from the EVE list to a new csv file
cut -d, -f9,10 ''$1'_BLAST_final_no_quotes.csv' > './bed_files/'$1'_locations.csv'

# Copy the direction (i.e. contig information) column from the EVE list to a new csv file
cut -d, -f13 ''$1'_BLAST_final_no_quotes.csv' > './bed_files/'$1'_names.csv'

# Copy just the accession numbers from the direction column only file
cd './bed_files'

cut -d' ' -f1 ''$1'_names.csv' > ''$1'_names2.csv'

#Combine the names and locations columns
csvjoin ''$1'_names2.csv' ''$1'_locations.csv' > ''$1'_final.csv'

# Change the field separator from comma to tab
sed -i 's/,/\t/g' ''$1'_final.csv' 

# Remove the header line
sed -i ''1d ''$1'_final.csv'

# Split the file into individual files
split ''$1'_final.csv' -l '1' -d $1

# Remove the original file
rm ''$1'_final.csv'

rm ''$1'_locations.csv'

rm ''$1'_names.csv'

rm ''$1'_names2.csv'

# Give a bed extension to all the new bed files
find . -type f -exec mv '{}' '{}'.bed \;

# Make a directory to hold the nucleotide sequence files
cd '/base_directory/'

mkdir './nt_sequences'

# Extract EVE nucleotide sequences from the genome using the bed files
cd '/base_directory/'$1'/bed_files' 

for b in *.bed; do bedtools getfasta -fo '/base_directory/'$1'/nt_sequences/'${b%%.*}'.fasta' -fi '/base_directory/'$1'/'$1'_genome.fasta' -bed $b; done 

# Make new directory to contain BLAST results of BLASTx of EVE nt sequences against D. melanogaster proteome
cd '/base_directory/'$1''

mkdir './BLAST_results'

# BLAST EVE nt sequences against D. melanogaster proteome
cd '/base_directory/'$1'/nt_sequences' 

for f in *.fasta; do blastx -db '/Path_to_directory_with_Drosophila_proteome_blastdb/Drosophila_proteome_with_spaces_converted_to_underscores' -query $f -max_target_seqs 1 -max_hsps 1 -evalue .001 -outfmt 10 -num_threads 15 -out '/base_directory/'$1'/BLAST_results/'${f%%.*}'.csv'; done

# Make a temporary folder to contain empty files. The empty files represent EVEs that did not match anything in the D. melanogaster proteome
cd '/base_directory/'$1'/BLAST_results' 

mkdir './temp'

# Move empty blast result csv files into the temporary folder
find -type f -size 0 -exec mv '{}' './temp/'{}'' \;

# Add the string "keep" to each empty file, move them back into the folder with the other csv files, and delete the temporary directory
cd './temp'

for c in *.csv; do echo 'keep' >> $c; done

for c in *.csv; do mv $c '/base_directory/'$1'/BLAST_results/'$c''; done

rm -rf '/base_directory/'$1'/BLAST_results/temp'

# Concatenate all the BLAST result csv files
cd '/base_directory/'$1'/BLAST_results'

cat *.csv > all.csv

# Insert a new row in the BLAST result CSV file and add the string "keep" to the new row. This will prevent the header line from being deleted later on

sed '1 i keep \' all.csv > all1.csv

# Create a new csv file containing only the first column of all1.csv

awk -F ',' '{print $1}' 'all1.csv' > 'all2.csv'

# Add all2.csv as a new column to the original list of EVEs
awk -F, '{getline f1<"/base_directory/'$1'/'$1'_BLAST_final.csv" ; print f1, $1}' OFS=, all2.csv > '/base_directory/'$1'/'$1'_Pre_Filter.csv' 

# Remove rows that don't have the string "keep" in them. These are EVEs that came up as similar to something in the D. melanogaster proteome
sed '/keep/!d' '/base_directory/'$1'/'$1'_Pre_Filter.csv' > '/base_directory/'$1'/'$1'_Post_Filter.csv'

#Run remove_duplicates.py and remove_in_frame.py scripts on the post_filter csv file
cd '/base_directory/'$1'/'$1'' 

python 'remove_duplicates.py' ''$1'_Post_Filter.csv' ''$1'_Post_Filter_Remove_Dups.csv'

python 'remove_in_frame.py' ''$1'_Post_Filter_Remove_Dups.csv' ''$1'_Post_Filter_Final.csv'
 



