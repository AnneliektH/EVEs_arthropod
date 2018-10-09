# !/bin/bash
species=$1

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



