# !/bin/bash
species=$1

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1'/bam_files/'

samtools view -bS ''$1'.sam' > ''$1'.bam'

