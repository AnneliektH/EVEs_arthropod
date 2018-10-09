# !/bin/bash

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do
  echo $D


  # Navigate to the base folder for the species
  # echo 'in clusters'
  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters/fastq'
  python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/length_with_0.py 'z_score.txt'

  # echo 'out clusters'
  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/fastq'
  python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/length_with_0.py 'z_score.txt'

done
