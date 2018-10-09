# !/bin/bash

species=$1
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do
  echo $D


  # Navigate to the base folder for the species
  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq'
  rm z_score.txt
  touch z_score.txt

  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq/individual_EVE_fastq/sense_fastq/length_distribution'

  for f in *.txt;
    do
      # echo $f
      python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/Z_score_21.py $f '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq/individual_EVE_fastq/antisense_fastq/length_distribution/'$f '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq/z_score.txt'
    done
done
