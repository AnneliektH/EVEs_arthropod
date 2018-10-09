#!/usr/bin/env python
# imports
import csv
import sys
import pandas as pd
from scipy import stats
import os
import numpy as np

# Open df sense, give column names
df_in_clusters = pd.read_csv(open(sys.argv[1]), sep=',')
df_out_clusters = pd.read_csv(open(sys.argv[2]), sep=',')

outfile = sys.argv[3]

# inside clusters
length_df_in = len(df_in_clusters['position_on_query_stop'])

if length_df_in > 1:
    df_in_clusters['length_EVE'] = df_in_clusters['position_on_query_stop'] - df_in_clusters['position_on_query_start']
else:
   df_in_clusters['length_EVE'] = 0


# outside clusters
length_df_out = len(df_out_clusters['position_on_query_stop'])

if length_df_out > 1:
    df_out_clusters['length_EVE'] = df_out_clusters['position_on_query_stop'] - df_out_clusters['position_on_query_start']
else:
   df_out_clusters['length_EVE'] = 0


df_len_in = df_in_clusters['length_EVE']
df_len_out = df_out_clusters['length_EVE']

species_name = os.path.basename(sys.argv[1])
total_length_in =  df_len_in.sum()
total_length_out = df_len_out.sum()

total_length_list = [species_name, total_length_in, total_length_out]
with open(outfile, 'a') as f:
    wr = csv.writer(f)
    wr.writerow(total_length_list)
