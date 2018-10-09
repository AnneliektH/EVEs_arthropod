# !/bin/bash
species=$1

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/'

sed 's/ /_/g' ''$1'_genome.fasta' > ''$1'_genome_no_space.fasta'

sed 's/,/_/g' ''$1'_genome_no_space.fasta' > ''$1'_genome_no_space_comma.fasta'

fasta_formatter -i ''$1'_genome_no_space_comma.fasta' -o ''$1'_genome_tabular.csv' -t

cut -f1 --complement ''$1'_genome_tabular.csv' > ''$1'_genome_seq.csv'

wc -m ''$1'_genome_seq.csv'
