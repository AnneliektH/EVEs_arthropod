"""
Script that counts specific viruses and gives them a family

Anneliek ter Horst 11/8/17
Takes in csv with all EVE information, puts out csv with only viral names
"""
# imports
import csv
import sys
import pandas as pd
import time
from collections import Counter

# Open the infile as pandas object
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index(drop=True)

# print length of csv
print len(df)

#  define start and end of viral name
start = '['
end = ']'

#  make a list for viral names
viral_name_list =[]

# Loop though rows in df, append each viral name from [] to name_list
for index, row in df.iterrows():
    sequence = row['sequence']
    result = sequence[sequence.find(start):sequence.find(end)+len(end)]

    # remove [] and all numbers in the viral name
    result = result.translate(None, '[]')
    viral_name_list.append(result)


# write to csv
with open(sys.argv[2],'w') as f:
    writer = csv.writer(f)
    for i in viral_name_list:
        writer.writerow([i])
# close file
f.close()
