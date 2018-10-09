# !/bin/bash
species=$1

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1''

echo whole genome

wc -l ''$1'_unsplit.csv'

echo out_clusters

wc -l './out_clusters/'$1'.csv'

echo on_clusters

wc -l './in_clusters/'$1'.csv'
