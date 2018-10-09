#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import os

# Open df
df = pd.read_csv(open(sys.argv[1]), names = ['length', 'number', 'X'])
# df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index(drop=True)

# species_name = os.path.basename(sys.argv[1])
# print species_name
total_EVE = len(df)
sign_21 = (df['number'] != 0).sum()

sign_21_list = [total_EVE, sign_21]
print sign_21_list
