#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd


# Open df
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index(drop=True)
df2 = pd.DataFrame.from_csv(open(sys.argv[2])).reset_index(drop=True)

df['nucleotide_num'] = df['nucleotide_num'].map(lambda x: x.rstrip('_filtered').rstrip(''))
df2['nucleotide_num'] = df2['nucleotide_num'].map(lambda x: x.rstrip('_filtered').rstrip(''))

df3 = df['nucleotide_num']
print df3

df3 = df3.append(df2['nucleotide_num'])
df3 = df3.astype(str) + '.txt'


df3.to_csv(sys.argv[3], sep = ' ', index=False, header=False)
