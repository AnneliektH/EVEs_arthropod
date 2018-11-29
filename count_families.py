#Anneliek ter Horst, 2017

# imports
import csv
import sys
import pandas as pd
import time
from collections import Counter
from collections import defaultdict


df = pd.DataFrame.from_csv(sys.argv[1]).reset_index()

df.columns= ['index', 'counts' ,'species', 'family']

df2 = df.groupby('family')['counts'].sum()
# df2 = df['family'].value_counts()

# df2 = pd.DataFrame.from_csv(sys.argv[2]).reset_index()
#
# df3 = df1.merge(df2, how='left', on='species')[['counts', 'species', 'family']].fillna('Unclassified')
#
df2.to_csv(sys.argv[2])
