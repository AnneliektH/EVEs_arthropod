# !/bin/bash



# Navigate to the base folder for the species
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Nucleotide_biases/out_clusters/'



for f in *.csv;
  do
    echo $f
    python /media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/print_nuclbias.py $f  '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/test_nucl_bias_out_clusters.csv'
  done
