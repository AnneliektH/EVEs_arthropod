#Anneliek ter Horst, 2018
#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd
from scipy import stats
from scipy.stats import binom_test
import os
import numpy as np
np.seterr(divide='ignore', invalid='ignore')

# turn off warning for dividing by 0
pd.options.mode.chained_assignment = None

# Open df, give column names. This is a two column space delimited csv file containing the length distribution for all sRNAs mapping to the EVE. One file for each EVE.
df1 = pd.read_csv(open(sys.argv[1]), sep=' ', names = ['length', 'number'])

outfile = sys.argv[2]

# get filename of opened file
EVE_number = os.path.basename(sys.argv[1])

# Open standard frame with values 18-36
df_standard = pd.read_csv(open('/directory_containing_standard.txt/standard.txt'),
                                        sep=' ', names = ['length', 'number_x'])

# merge with df from length reads, fill NaN with 0s
df2 = pd.merge(df_standard, df1, on='length', how='left')
df2 = df2.fillna(0)


# remove column with only 0 from the standard frame
df2 = df2.drop('number_x', 1)

# only take numbers between 18-36 into account for this one
df3 = df2.query('36 >= length')

# remove length of 21
df3 = df3[df3.length != 21]

# count total amount of sRNAs in this dataset
total_srna = df3['number'].sum()
# print total_srna

# count amount of sRNA in length range 24-32
df_piRNA =  df3.query('24 <= length <= 32 ')
total_pirna = df_piRNA['number'].sum()
# print total_pirna

# do binomial test
p_val = binom_test(total_pirna, total_srna, 9/19, alternative='two-sided')
# # append significant files to the list
with open(outfile, 'a') as f:
    # if p<0.01 then write filename to new file
    if p_val < 0.001:
        # print 'significant'
        # print EVE_number
        f.write(EVE_number + '\n')
