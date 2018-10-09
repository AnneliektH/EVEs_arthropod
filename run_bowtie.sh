# !/bin/bash
species=$1

cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1''

mkdir './bam_files'

bowtie-build ''$1'_genome.fasta' ''$1'_genome'

bowtie ''$1'_genome' -q './sRNA_datasets/length_trimmed/'$1'_all.fastq' -S './bam_files/'$1'.sam' --verbose

samtools view -bS ''$1'.sam' > ''$1'_srna_mapped.bam'



