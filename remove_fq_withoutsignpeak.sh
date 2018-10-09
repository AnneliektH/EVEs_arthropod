# !/bin/bash
species=$1

# navigate to species folder, take each species name
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do
  echo $D

  # Navigate to the base folder for the species
  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq'

  for file in *
    do grep -q -F ${file%%.*} '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq/p_val_piRNA.txt' || rm ${file%%.*}'.fastq'
  done
done
