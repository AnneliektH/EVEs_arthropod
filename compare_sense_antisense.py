#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import scipy
import scipy.stats
import re

# Open df with all nucleotide numbers
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index()

# give names to columns, makes everything easier
df.columns = ['nucleotide_num', 'count', 'A_count', 'C_count', 'G_count', 'T_count', 'N_count']

# remove all the extra headers
df = df[~df['count'].str.contains('count')]

# remove the mapped files that only had one read
df = df.loc[df['count'] != '1']
df = df.loc[df['count'] != '2']


# make an int from the amount of times nucleotide was counted
df['count'] = df['count'].apply(int)
df['A_count'] = df['A_count'].apply(int)
df['C_count'] = df['C_count'].apply(int)
df['G_count'] = df['G_count'].apply(int)
df['T_count'] = df['T_count'].apply(int)
df['N_count'] = df['N_count'].apply(int)


# count binominal test of ACTGN
df['A_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['A_count'], x['count'], 0.25, 'greater'), axis=1)
df['T_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['T_count'], x['count'], 0.25, 'greater'), axis=1)


# make a definition for significant T bias
sign_T_bias = df['T_binom'] < 0.01
# make a definition for significant A bias
sign_A_bias = df['A_binom'] < 0.01


# Make a new df for all the primary piRNAs (1T bias)
df1 = df[sign_T_bias]
df2 = df[sign_A_bias]

# Remove all T bias in 10th nucl for df with only T bias
df1 = df1[~df1['nucleotide_num'].str.contains('filtered.csv:9')]
df2 = df2[~df2['nucleotide_num'].str.contains('filtered.csv:0')]

# rename the columns in the dataframes, so the names can be recognized in the merged df
df1.columns = ['nucleotide_num', 'count_1', 'A_count_1', 'C_count_1', 'G_count_1', 'T_count_1', 'N_count_1', 'A_binom_1', 'T_binom_1']
df2.columns = ['nucleotide_num', 'count_10', 'A_count_10', 'C_count_10', 'G_count_10', 'T_count_10', 'N_count_10', 'A_binom_10', 'T_binom_10']

# remove the end part of strings (.csv:0)
df1['nucleotide_num'] = df1['nucleotide_num'].map(lambda x: str(x)[:-6])
df2['nucleotide_num'] = df2['nucleotide_num'].map(lambda x: str(x)[:-6])

# Merhe the dataframe based on which bed file it originated from. So sense and antisense match
df1.to_csv(sys.argv[2])
df2.to_csv(sys.argv[3])
