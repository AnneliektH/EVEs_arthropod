# !/bin/bash
species=$1

# Make a new bed file from the BLAST- and manually-filtered EVE list
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

mkdir './bed_files'

cd './bed_files'

mkdir './temp'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

cut -d, -f13 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/temp/'$1'_1st.csv' 

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/temp/'

sed -i 's/"//g' ''$1'_1st.csv' 

awk '{print $1}' ''$1'_1st.csv' > ''$1'_contig.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

cut -d, -f9 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/temp/'$1'_2nd.csv'

cut -d, -f10 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/temp/'$1'_3rd.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/temp/'

paste -d, ''$1'_contig.csv' ''$1'_2nd.csv' | sed 's/^,//; s/,$//' > ''$1'_temp.csv'

paste -d, ''$1'_temp.csv' ''$1'_3rd.csv' | sed 's/^,//; s/,$//' > ''$1'_comma.csv'

sed -i 1d ''$1'_comma.csv' 

sed 's/,/\t/g' ''$1'_comma.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/'$1'.bed'

rm *.csv

# Filter Annelieks bam file to remove unmapped reads
samtools view -F 4 -b '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped.bam' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped_JCN.bam'

# Use the new bed file to filter the bam file Anneliek made
samtools view -L '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/'$1'.bed' -b '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped_JCN.bam' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/'$1'_all_EVEs.bam'

# Extract reads from the bam files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

mkdir './fastq'

cd './fastq'

mkdir './all_EVEs'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

bedtools bamtofastq -i '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/'$1'_all_EVEs.bam' -fq './fastq/all_EVEs/'$1'.fastq'

#Filter the fastq_files based on length

cd './fastq/all_EVEs'

awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 18 && length(seq) <= 36) {print header, seq, qheader, qseq}}' < ''$1'.fastq' > ''$1'_length_filtered.fastq'

# Print the length distribution
mkdir './length_distribution'

awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' ''$1'_length_filtered.fastq' > './length_distribution/'$1'.txt'

# Add headers
cd './length_distribution'

mkdir './headers'

sed 's/ /,/g' ''$1'.txt' > './headers/'$1'.csv'

cd './headers'

sed -i 1i'length, count' ''$1'.csv'  

# Do the same thing for EVEs in piRNA clusters
# Make a new bed file from the BLAST- and manually-filtered EVE list
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

mkdir './bed_files'

cd './bed_files'

mkdir './temp'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

cut -d, -f13 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/temp/'$1'_1st.csv' 

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/temp/'

sed -i 's/"//g' ''$1'_1st.csv' 

awk '{print $1}' ''$1'_1st.csv' > ''$1'_contig.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

cut -d, -f9 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/temp/'$1'_2nd.csv'

cut -d, -f10 ''$1'.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/temp/'$1'_3rd.csv'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/temp/'

paste -d, ''$1'_contig.csv' ''$1'_2nd.csv' | sed 's/^,//; s/,$//' > ''$1'_temp.csv'

paste -d, ''$1'_temp.csv' ''$1'_3rd.csv' | sed 's/^,//; s/,$//' > ''$1'_comma.csv'

sed -i 1d ''$1'_comma.csv' 

sed 's/,/\t/g' ''$1'_comma.csv' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/'$1'.bed'

rm *.csv

# Use the new bed file to filter the bam file Anneliek made
samtools view -L '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/'$1'.bed' -b '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped_JCN.bam' > '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/'$1'_all_EVEs.bam'

# Extract reads from the bam files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

mkdir './fastq'

cd './fastq'

mkdir './all_EVEs'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

bedtools bamtofastq -i '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/'$1'_all_EVEs.bam' -fq './fastq/all_EVEs/'$1'.fastq'

#Filter the fastq_files based on length

cd './fastq/all_EVEs'

awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 18 && length(seq) <= 36) {print header, seq, qheader, qseq}}' < ''$1'.fastq' > ''$1'_length_filtered.fastq'

# Print the length distribution
mkdir './length_distribution'

awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' ''$1'_length_filtered.fastq' > './length_distribution/'$1'.txt'

# Add headers
cd './length_distribution'

mkdir './headers'

sed 's/ /,/g' ''$1'.txt' > './headers/'$1'.csv'

cd './headers'

sed -i 1i'length, count' ''$1'.csv'
# Make a copy of the BED file in a new folder
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files'

mkdir './individual_EVE_bed_files/'

cp ''$1'.bed' './individual_EVE_bed_files/'

# Split the BED file containing all EVEs into individual EVEs for each bed file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/individual_EVE_bed_files'

split ''$1'.bed' -l '1' -d $1

rm ''$1'.bed'

find . -type f -exec mv '{}' '{}'.bed \;

# Filter the all EVEs bam file based on the individual EVE bed files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters'

mkdir './individual_EVE_bam_files'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/bed_files/individual_EVE_bed_files'

for b in *.bed; do samtools view -L $b -b '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped_JCN.bam' >'/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/'${b%%.*}'.bam'; done

# Convert bam files to fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq'

mkdir './individual_EVE_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/'${b%%.*}'.fastq'; done

# Print the length distribution
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Add headers
cd './length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done 

# Navigate to the directory containing individual unstranded BAM files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files'

# Make new directories for sense and antisense BAM files
mkdir './Sense'

mkdir './Antisense'

# Split the BAM files into sense and antisense
for b in *.bam; do samtools view -F 16 -b $b > './Sense/'${b%%.*}'.bam'; done

for b in *.bam; do samtools view -f 16 -b $b > './Antisense/'${b%%.*}'.bam'; done

# Convert sense BAM files into fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq'

mkdir './sense_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/Sense'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/'${b%%.*}'.fastq'; done

# Convert antisense BAM files into fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq'

mkdir './antisense_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/Antisense'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/'${b%%.*}'.fastq'; done

# Calculate length distribution for Sense fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Calculate length distribution for Antisense fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Add headers to the sense distributions
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done

# Add headers to the antisense distributions
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done

# Make a copy of the BED file in a new folder
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files'

mkdir './individual_EVE_bed_files/'

cp ''$1'.bed' './individual_EVE_bed_files/'

# Split the BED file containing all EVEs into individual EVEs for each bed file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/individual_EVE_bed_files'

split ''$1'.bed' -l '1' -d $1

rm ''$1'.bed'

find . -type f -exec mv '{}' '{}'.bed \;

# Filter the all EVEs bam file based on the individual EVE bed files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters'

mkdir './individual_EVE_bam_files'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/bed_files/individual_EVE_bed_files'

for b in *.bed; do samtools view -L $b -b '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'$1'_srna_mapped_JCN.bam' >'/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/'${b%%.*}'.bam'; done

# Convert bam files to fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq'

mkdir './individual_EVE_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/'${b%%.*}'.fastq'; done

# Print the length distribution
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Add headers
cd './length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done 

# Navigate to the directory containing individual unstranded BAM files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files'

# Make new directories for sense and antisense BAM files
mkdir './Sense'

mkdir './Antisense'

# Split the BAM files into sense and antisense
for b in *.bam; do samtools view -F 16 -b $b > './Sense/'${b%%.*}'.bam'; done

for b in *.bam; do samtools view -f 16 -b $b > './Antisense/'${b%%.*}'.bam'; done

# Convert sense BAM files into fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq'

mkdir './sense_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/Sense'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/'${b%%.*}'.fastq'; done

# Convert antisense BAM files into fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq'

mkdir './antisense_fastq'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/Antisense'

for b in *.bam; do bedtools bamtofastq -i $b -fq '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/'${b%%.*}'.fastq'; done

# Calculate length distribution for Sense fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Calculate length distribution for Antisense fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/'

mkdir './length_distribution'

for f in *.fastq; do awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' $f > './length_distribution/'${f%%.*}'.txt'; done

# Add headers to the sense distributions
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done

# Add headers to the antisense distributions
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/length_distribution'

mkdir './headers'

for t in *.txt; do sed 's/ /,/g' $t > './headers/'${t%%.*}'.csv'; done

cd './headers'

for c in *.csv; do sed -i 1i'length, count' $c; done


  






