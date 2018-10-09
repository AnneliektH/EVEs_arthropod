#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd
from scipy import stats
import os
import numpy as np
np.seterr(divide='ignore', invalid='ignore')

# turn off warning for dividing by 0
pd.options.mode.chained_assignment = None

# Open df sense, give column names
df_sense = pd.read_csv(open(sys.argv[1]), sep=' ', names = ['length', 'number'])

# Open df antisense, give column names
df_antisense = pd.read_csv(open(sys.argv[2]), sep=' ', names = ['length', 'number'])

outfile = sys.argv[3]

# get filename of opened file
EVE_number = os.path.basename(sys.argv[1])

# Open standard frame with values 18-36
df_standard = pd.read_csv(open('/media/falklabuser/LargeData/Anneliek/new_EVEs_both/species/aaegypti/in_clusters/fastq/standard.txt'),
                                        sep=' ', names = ['length', 'number_x'])

# merge with df from length reads, fill NaN with 0s
new_df_sense = pd.merge(df_standard, df_sense, on='length', how='left')
new_df_sense= new_df_sense.fillna(0)


# merge with df from length reads, fill NaN with 0s
new_df_antisense = pd.merge(df_standard, df_antisense, on='length', how='left')
new_df_antisense= new_df_antisense.fillna(0)

# remove column with only 0 from the standard frame
new_df_sense = new_df_sense.drop('number_x', 1)
new_df_antisense = new_df_antisense.drop('number_x', 1)

# only take numbers between 18-24 into account for this one
df_siRNA_sense = new_df_sense.query('24 >= length')

df_siRNA_antisense = new_df_antisense.query('24 >= length')


# define columns for Z score
columns = list(df_sense)

# calculate Z score of all values between 18-24, append to df sense
for col in columns:
    col_zscore = col + 'z_score'
    df_siRNA_sense[col_zscore] = stats.zscore(df_siRNA_sense[col])

for col in columns:
    col_zscore = col + 'z_score'
    df_siRNA_antisense[col_zscore] = stats.zscore(df_siRNA_antisense[col])


# get Z score only for length 21, = index number 3
z_score_sense = df_siRNA_sense.get_value(3, 'numberz_score')

z_score_antisense = df_siRNA_antisense.get_value(3, 'numberz_score')

# make a list of the file name, both z scores
if z_score_sense >= 1.96 and z_score_antisense >= 1.96:
    z_score_list = [EVE_number, z_score_sense, z_score_antisense]
    print 'significant'
else:
    z_score_list = [0,0,0]

# put Z score of both sense and antisense in new df, with distinctive file name
with open(outfile, 'a') as f:
    wr = csv.writer(f)
    wr.writerow(z_score_list)
