# !/bin/bash
species=$1

# Copy the proTRAC files to the folder containing the length trimmed fastq files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC'

cp '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC/proTRAC_2.3.1.pl' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

cp '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC/reallocate.pl' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

cp '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC/sRNAmapper.pl' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

cp '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC/TBr2_collapse.pl' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

cp '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/proTRAC/TBr2_duster.pl' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

# Copy the genome of the species to the folder containing the sRNA sequences
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1''

cp ''$1'_genome.fasta' './sRNA_datasets/length_trimmed'

# Navigate to the directory
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets/length_trimmed'

# Convert the fastq file to a fastq file
fastq_to_fasta -i ''$1'_all.fastq' -o ''$1'_all.fasta'

# Run proTRAC
perl TBr2_collapse.pl -i ''$1'_all.fasta' -o ''$1'_all.collapsed'

perl TBr2_duster.pl -i ''$1'_all.collapsed'

perl sRNAmapper.pl -input ''$1'_all.collapsed.no-dust' -genome ''$1'_genome.fasta' -alignments best

perl proTRAC_2.3.1.pl -map ''$1'_all.collapsed.no-dust.map' -genome ''$1'_genome.fasta' -swsize 1000 -swincr 500 -clsize 1500 -pdens 0.1



 
