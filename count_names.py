#Anneliek ter Horst, 2017

# imports
import csv
import sys
import pandas as pd
import time
from collections import Counter
import itertools

# Open taxonomy database
df = pd.DataFrame.from_csv(sys.argv[1]).reset_index()

print len(df)
df.columns= ['species']

fam_list= []
# df = df[df.species.str.contains('Musca domestica salivary gland hypertrophy virus') == False]
# df = df[df.species.str.contains('Glossina pallidipes salivary gland hypertrophy virus') == False]

for index, row in df.iterrows():
     fam_list.append(row[0])

# # df['family2'].str.cat(sep= ',')
counts = Counter(fam_list)

# Make an output file with only family and species
# open output file
with open(sys.argv[2], 'w') as fout:
    # write a header
    fieldnames = ['species', 'counts']
    writer = csv.writer(fout)
    writer.writerow(fieldnames)

    # Write counts to csv

    writer.writerows(counts.items())
    # close output
    fout.close()
