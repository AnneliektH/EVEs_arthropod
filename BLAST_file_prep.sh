# !/bin/bash
species=$1

# Navigate to the folder containing the BLAST results
cd '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/'$1''

# Run parse_andfilter_xml.py on the BLAST results
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/parse_andfilter_xml.py' ''$1'_BLAST.xml' ''$1'_BLAST.csv'

# Run len_df.py on the BLAST results
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/len_df_JCN.py' ''$1'_BLAST.csv' ''$1'_BLAST_remove_unwanted.csv'

# Run remove_duplicates.py on the output of len_df.py
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/remove_duplicates.py' ''$1'_BLAST_remove_unwanted.csv' ''$1'_BLAST_remove_duplicates.csv'

# Run remove_in_frame.py on the output of remove_duplicates.py
python '/media/falklabuser/LargeData/Anneliek/new_EVEs_both/Scripts/remove_in_frame.py' ''$1'_BLAST_remove_duplicates.csv' ''$1'_BLAST_final.csv'

 
 


