# !/bin/bash

# navigate to species folder and do python script for each species
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species'
for D in *; do
  echo $D

  cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/in_clusters';
      echo $D'.csv'
      python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/calculate_total_size_of_clusters.py $D'.csv'  '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$D'/out_clusters/'$D'.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/clustersizes.csv'
    done
  done
