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

for s in *.sam; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/signature.py' $s '24' '32' '0' '20' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/for_z_score/'${s%%.*}'.txt'; done

# Run Anneliek's extract_for_zscore.py script on the output files from merge_sense_antisense.py
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/extract_for_zscore.py' 'merged_on_1antisense.csv' 'merged_on_1sense.csv' $1'_for_Z_score.csv'

# Do whatever this does to mave some of the files from '~/for_z_score' to '~/only_secondary'
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files'

mkdir './only_secondary'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/for_z_score/'

xargs -a '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/fastq/individual_EVE_fastq/'$1'_for_Z_score.csv' mv -t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/only_secondary'

# Run Annelieks script find_sign_P.py to find EVEs with a Z-score above 3.2905, which corresponds to a p-value of .001 given a two-tailed hypothesis. Print the results to a new file, which has the word "significant" for each time there is a significant EVE
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/in_clusters/individual_EVE_bam_files/only_secondary'

for f in *.txt; do echo $f; '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/find_sign_P.py' $f | tee -a '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/sig_z_scores/in_clusters/'$1'_significant.txt'; done

# Do the same thing for EVEs outside piRNA clusters
# !/bin/bash
species=$1

# Navigate to the base folder for the species
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq'

# Merge sense and antisense files
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/merge_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/T_bias_sense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/A_bias_antisense.csv' 'merged_on_1sense.csv'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/merge_sense_antisense.py' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/antisense_fastq/piRNA_length_range/T_bias_antisense.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/sense_fastq/piRNA_length_range/A_bias_sense.csv' 'merged_on_1antisense.csv'

# Navigate to the base folder for the species and make the necessary directories 
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files'

mkdir 'for_z_score'
mkdir 'sam_files'

# Convert the individual EVE BAM files into SAM files
for b in *.bam; do samtools view -h -o './sam_files/'${b%%.*}'.sam' $b; done

# Run signature.py on the SAM files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/sam_files'

for s in *.sam; do python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/signature.py' $s '24' '32' '0' '20' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/for_z_score/'${s%%.*}'.txt'; done

# Run Anneliek's extract_for_zscore.py script on the output files from merge_sense_antisense.py
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq'

python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/extract_for_zscore.py' 'merged_on_1antisense.csv' 'merged_on_1sense.csv' $1'_for_Z_score.csv'

# Do whatever this does to mave some of the files from '~/for_z_score' to '~/only_secondary'
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files'

mkdir './only_secondary'

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/for_z_score/'

xargs -a '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/fastq/individual_EVE_fastq/'$1'_for_Z_score.csv' mv -t '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/only_secondary'

# Run Annelieks script find_sign_P.py to find EVEs with a Z-score above 3.2905, which corresponds to a p-value of .001 given a two-tailed hypothesis. Print the results to a new file, which has the word "significant" for each time there is a significant EVE
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/out_clusters/individual_EVE_bam_files/only_secondary'

for f in *.txt; do echo $f; '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/find_sign_P.py' $f | tee -a '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/sig_z_scores/out_clusters/'$1'_significant.txt'; done
 


