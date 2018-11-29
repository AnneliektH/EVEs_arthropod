"""
Compare a csv with only viral names to csv with the taxonomy of viruses,
this csv comes from https://gitlab.com/zyxue/ncbitax2lin-lineages/blob/master/lineages-latest.csv.gz
and was adapted to only contain viral names.

Anneliek ter Horst
17/11/17
"""


# imports
import csv
import sys
import pandas as pd
import time
from collections import Counter


# DataFrame for families
family_dict = {}

# Open taxonomy database
df_taxonomy = pd.DataFrame.from_csv(sys.argv[1])

# Open insect EVE viral name file
df_species = pd.DataFrame.from_csv(sys.argv[2]).reset_index()

# rename the column in EVE file
df_species.columns= ['species_name']

# Print length of both dfs
print len(df_taxonomy)
print len(df_species)

# Make a list of all the known viral names in database
# So later on I can check if entrie is in this list
viral_name_list =[]

# List to skip if species has been looked at
to_be_skipped = []

# loop through both data frames
for index_t, row_t in df_taxonomy.iterrows():
    viral_name_list.append(row_t[2])

# Loop through both dataframes
for index_t, row_t in df_taxonomy.iterrows():
    for index_s, row_s in df_species.iterrows():
        # compare viral names in database with names in own file
        if row_s[0] == row_t[2] and index_s not in to_be_skipped:

            # If names match, add family to family list
            # print 'virus name is', row_s[0], row_t[2]
            # print 'family is', row_t[0]
            # print 'index is', index_s

            # Add the index to the skipping list (so it wont be looked at double)
            to_be_skipped.append(index_s)

            # add viral family to the list of found families
            family_dict[row_s[0]] = row_t[0]

        # If viral name not found in database
        if row_s[0] not in viral_name_list and index_s not in to_be_skipped:
            # Add the index to the skipping list (so it wont be looked at double)
            to_be_skipped.append(index_s)

            # Add Unclassified to viral family list
            # print 'virus name is', row_s[0]
            # print 'index is', index_s
            # print 'family not found'
            family_dict[row_s[0]] = 'unclassified'

# # count the families in the family list
# counts = Counter(family_list)

# # print the counts
# print counts

print family_dict


# Make an output file with only family and species
# open output file
with open(sys.argv[3], 'w') as fout:
    # write a header
    fieldnames = ['species', 'family']
    writer = csv.writer(fout)
    writer.writerow(fieldnames)

    # Write counts to csv
    for key, value in family_dict.items():
            writer.writerow([key] + [value])
    # close output
    fout.close()
