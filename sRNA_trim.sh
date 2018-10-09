# !/bin/bash
species=$1

# Navigate to the folder containing the sRNA datasets
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/sRNA_datasets'

# Remove adaptors from the sRNA sequences
for f in *.fastq; do perl '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/trim_galore_v0.4.4/trim_galore' --length 18 $f; done

# Filter trimmed sRNA datasets based on length
mkdir './length_trimmed'

for f in *.fq; do awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 18 && length(seq) <= 36) {print header, seq, qheader, qseq}}' < $f > './length_trimmed/'${f%%.*}'.fastq'; done

# # Combine the sRNA datasets into a single dataset
# cd './length_trimmed'
#
# cat '*.fastq' > ''$1'_all.fastq'
