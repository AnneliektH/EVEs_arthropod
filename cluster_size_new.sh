# !/bin/bash
species=$1

cd '/media/falklabuser/LargeData/Anneliek/cluster_files/with_>'

sed 's/ /_/g' ''$1'_clusters.fasta' > ''$1'_clusters_no_space.fasta'

sed 's/,/_/g' ''$1'_clusters_no_space.fasta' > ''$1'_clusters_no_space_comma.fasta'

fasta_formatter -i ''$1'_clusters_no_space_comma.fasta' -o ''$1'_clusters_tabular.csv' -t

cut -f1 --complement ''$1'_clusters_tabular.csv' > ''$1'_clusters_seq.csv'

wc -m ''$1'_clusters_seq.csv'
