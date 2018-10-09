#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import scipy
import scipy.stats
import re

# Open df with all nucleotide numbers
df1 = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index()
df2 = pd.DataFrame.from_csv(open(sys.argv[2])).reset_index()

df3 = pd.merge(df1, df2, on='nucleotide_num')

# Merhe the dataframe based on which bed file it originated from. So sense and antisense match
df3.to_csv(sys.argv[3])
