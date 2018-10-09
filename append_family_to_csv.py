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
import numpy as np


# Open taxonomy database
df_taxonomy = pd.DataFrame.from_csv(sys.argv[1])

# Open insect EVE viral name file
df_species = pd.DataFrame.from_csv(sys.argv[2]).reset_index()

# rename the column in EVE file
df_species.columns= ['species_name']
# new column for family
df_species['family'] = np.nan

# Print length of both dfs
print len(df_taxonomy)
print len(df_species)

# Make a list of all the known viral names in database
# So later on I can check if entrie is in this list
viral_name_list =[]

# loop through both data frames
for index_t, row_t in df_taxonomy.iterrows():
    viral_name_list.append(row_t[2])

# Loop through both dataframes
for index_t, row_t in df_taxonomy.iterrows():
    for index_s, row_s in df_species.iterrows():
        # compare viral names in database with names in own file
        if row_s[0] == row_t[2]:
            # add viral family to the list of found families
            df_species['family'] = row_t[0]


        # If viral name not found in database
        elif row_s[0] not in viral_name_list:
            # Add Unclassified to viral family list
            df_species['family'] = 'unclassified'


print df_species
# # Make an output file with only family and species
df_species.to_csv(sys.argv[3])
