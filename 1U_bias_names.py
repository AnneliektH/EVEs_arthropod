# Anneliek ter Horst, 2017

#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import scipy
import scipy.stats

# Open df with all nucleotide numbers
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index()
df2 = pd.DataFrame.from_csv(open(sys.argv[2])).reset_index()

df3 = pd.DataFrame.from_csv(open(sys.argv[3])).reset_index()
df4 = pd.DataFrame.from_csv(open(sys.argv[4])).reset_index()

df['same'] = df.nucleotide_num.isin(df2.nucleotide_num).astype(int)
df2['same'] = df2.nucleotide_num.isin(df.nucleotide_num).astype(int)

print 'sense', df3
print 'antisense', df4
print 'both directions', sum(df['same'])
# print sum(df2['same'])
