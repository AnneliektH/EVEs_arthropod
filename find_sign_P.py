#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd


# Open df
df = pd.DataFrame.from_csv(open(sys.argv[1]), sep = '\t').reset_index(drop=True)

if df.ix[10]['z-score'] > 3.2905:
    print 'significant'
