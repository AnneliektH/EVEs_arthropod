# !/bin/bash
species=$1

# Navigate to the base folder for the species
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq'

# Merge sense and antisense files
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/merge_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/T_bias_sense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/A_bias_antisense.csv' 'merged_on_1sense.csv'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/merge_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/T_bias_antisense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/A_bias_sense.csv' 'merged_on_1antisense.csv'

# Navigate to the base folder for the species and make the necessary directories 
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files'

mkdir 'for_z_score'
mkdir 'sam_files'

# Convert the individual EVE BAM files into SAM files
for b in *.bam; do samtools view -h -o './sam_files/'${b%%.*}'.sam' $b; done

# Run signature.py on the SAM files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/sam_files'

for s in *.sam; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/signature.py' $s '26' '32' '0' '20' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/for_z_score/'${s%%.*}'.txt'; done
