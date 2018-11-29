#Anneliek ter Horst, 2017

# imports
import csv
import sys
import pandas as pd
import time
from collections import Counter
from collections import defaultdict

# species
df1 = pd.DataFrame.from_csv(sys.argv[1]).reset_index()
# database
df2 = pd.DataFrame.from_csv(sys.argv[2]).reset_index()

# new df
df3 = df1.merge(df2, how='left', on='species')[['counts', 'species', 'family']].fillna('Unclassified')

df3.to_csv(sys.argv[3])
