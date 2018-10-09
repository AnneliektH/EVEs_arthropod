# !/bin/bash
species=$1

# This script removes from a whole genome EVE list any EVEs that are also present in the piRNA cluster EVE list. I am only using this script for the following species: A. aegypti, A. albopictus, B. germanica, D. citri, H. melpomene, H. vitripennis, I. scapularis, and P. interpunctella. The rest of the species were already split into in clusters and out clusters by Anneliek and then hand filtered by me. This is a three part script.

# Navigate to the folder containing Anneliek's EVEs in piRNA cluster files
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Anneliek_in_cluster_files'

# Copy the sequence column to a new file
awk -F"," '{print $2}' ''$1'.csv' > ''$1'_seqs.csv'

# Cut everything in front of the accession number in the sequence column to a new file
cut -d' ' -f 1 --complement ''$1'_seqs.csv' > ''$1'_seq2.csv'

## Now you have to manually replace the sequence column from $1.csv with $1_seqs2.csv. Then run split_clusters3. This will acutally filter the files.
