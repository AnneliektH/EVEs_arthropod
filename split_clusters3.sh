# !/bin/bash
species=$1

# This script removes from a whole genome EVE list any EVEs that are also present in the piRNA cluster EVE list. I am only using this script for the following species: A. aegypti, A. albopictus, B. germanica, D. citri, H. melpomene, H. vitripennis, I. scapularis, and P. interpunctella. The rest of the species were already split into in clusters and out clusters by Anneliek and then hand filtered by me. This is a three part script.

# Navigate to the folder containing the unsplit EVE file
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1''

# Run the whole genome EVE list and the piRNA cluster EVE list through remove_picluster_mod2.py
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/remove_picluster_mod2.py' ''$1'_unsplit.csv' '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Anneliek_in_cluster_files/'$1'.csv' './out_clusters/'$1'_df3.csv' './out_clusters/'$1'_df4.csv' './out_clusters/'$1'_df5.csv' './in_clusters/'$1'.csv'

# Delete the header line from df4 and df 5 
cd './out_clusters'

sed -i 1d ''$1'_df4.csv' 

sed -i 1d ''$1'_df5.csv'

# Concatenate df3, df4, and df5
cat  ''$1'_df3.csv' ''$1'_df4.csv' ''$1'_df5.csv' > ''$1'.csv'

wc -l ''$1'.csv'
