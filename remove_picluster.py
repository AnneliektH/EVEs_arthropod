#Anneliek ter Horst, 2017

#!/usr/local/bin/python

# imports
import csv
import sys
import pandas as pd
import numpy as np



# genome
df1 = pd.DataFrame.from_csv(open(sys.argv[1]))
# clusters
df2 = pd.DataFrame.from_csv(open(sys.argv[2]))

# df2 = df2[['sequence', 'direction']]

# df2.columns =['sequence', 'direction']

# df1['same'] = (df1[['sequence', 'direction']] == df2[['sequence', 'direction']]).all(axis=1).astype(int)

# df2['direction'] = df['direction'].str.split('')


df1['same'] = df1.sequence.isin(df2.sequence).astype(np.int8)
df1['same2'] = df1.perc_identity.isin(df2.perc_identity).astype(np.int8)
# df1['same3'] = df1.position_on_hit_stop.isin(df2.position_on_hit_stop).astype(np.int8)

df3 = df1[(df1['same'] == 0) & (df1['same2'] == 0)]
df4 = df1[(df1['same'] == 1) & (df1['same2'] == 0)]
df5 = df1[(df1['same'] == 0) & (df1['same2'] == 1)]
df6 = df1[(df1['same'] == 1) & (df1['same2'] == 1)]


print len(df1)
print len(df2)
print len(df3)
print len(df4)
print len(df5)
print len(df6)

df3.to_csv(sys.argv[3])
df4.to_csv(sys.argv[4])
df5.to_csv(sys.argv[5])
df6.to_csv(sys.argv[6])
