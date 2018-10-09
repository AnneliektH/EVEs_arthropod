# !/bin/bash

species=$1
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do
  echo $D


  # Navigate to the base folder for the species
  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/fastq'
  touch p_val_piRNA.txt

  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/fastq/individual_EVE_fastq/length_distribution'

  for f in *.txt;
    do
      # echo $f
      python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/sign_piRNA_peak.py $f '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/fastq/p_val_piRNA.txt'
    done
done
