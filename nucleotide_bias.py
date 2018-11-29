#Anneliek ter Horst, 2017

#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd


# Open df
df = pd.DataFrame.from_csv(open(sys.argv[1]), sep='\t').reset_index(drop=True)
# df.reset_index(level=0, inplace=True)
df.columns = ['count', 'min', 'max', 'sum', 'mean', 'Q1', 'med', 'Q3', 'IQR', 'lW', 'rW', 'A_Count', 'C_Count', 'G_Count', 'T_Count', 'N_Count', 'Max_count']

df1 = df.drop(['min', 'max', 'sum', 'mean', 'Q1', 'med', 'Q3', 'IQR', 'lW', 'rW', 'Max_count'], axis=1)
df2 = df1.iloc[[0,9],:]

df2.to_csv(sys.argv[2])
