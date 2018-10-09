
# imports
import csv
import sys
import pandas as pd


# Open df
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index(drop=True)

print len(df)
