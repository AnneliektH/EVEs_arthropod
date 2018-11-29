#Anneliek ter Horst, 2017

#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import scipy
import scipy.stats

# Open df with all nucleotide numbers
df = pd.DataFrame.from_csv(open(sys.argv[1])).reset_index()

# give names to columns, makes everything easier
df.columns = ['nucleotide_num', 'count', 'A_count', 'C_count', 'G_count', 'T_count', 'N_count']

# remove all the extra headers
df = df[~df['count'].str.contains('count')]

# remove the mapped files that only had one read
df = df.loc[df['count'] != '1']
df = df.loc[df['count'] != '2']

# make a string from the nucleotide number
df['nucleotide_num'] = df['nucleotide_num'].replace({0 : '1', 9 : '10'})

# make an int from the amount of times nucleotide was counted
df['count'] = df['count'].apply(int)
df['A_count'] = df['A_count'].apply(int)
df['C_count'] = df['C_count'].apply(int)
df['G_count'] = df['G_count'].apply(int)
df['T_count'] = df['T_count'].apply(int)
df['N_count'] = df['N_count'].apply(int)


# count binominal test of ACTGN
df['A_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['A_count'], x['count'], 0.25, 'greater'), axis=1)
df['C_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['C_count'], x['count'], 0.25, 'greater'), axis=1)
df['T_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['T_count'], x['count'], 0.25, 'greater'), axis=1)
df['G_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['G_count'], x['count'], 0.25, 'greater'), axis=1)
df['N_binom'] = df.apply(lambda x: scipy.stats.binom_test(x['N_count'], x['count'], 0.25, 'greater'), axis=1)

# make a definition for significant T bias
sign_T_bias = df['T_binom'] < 0.001
# make a definition for significant A bias
sign_A_bias = df['A_binom'] < 0.001

# Set the nucleotide number that needs to have this T bias
nucleotide_one = df['nucleotide_num'] == '1'

# Set the nucleotide number that needs to have this A bias
nucleotide_ten = df['nucleotide_num'] == '10'

# Make a new df for all the primary piRNAs (1T bias)
df1 = df[sign_T_bias & nucleotide_one]

# make a new df for all the reads that have a 10A bias
df2 = df[sign_A_bias & nucleotide_ten]

# Make a list for the index of all the reads with a one T bias
oneT_bias_index = df1.index.tolist()

# Make the same list of indexes for all with ten A bias
tenA_bias_index = df2.index.tolist()

# For all the indices with ten A bias, subtract one. So the numbers will correspond to
# the numbers in the index for one T bias -> so same number in both lists means that there is both a 1T and 10A bias.
tenA_one = [x-1 for x in tenA_bias_index]

# Match the indices
matching_index = set(oneT_bias_index).intersection(tenA_one)


# Print the lengths of dataframe
primary_bias = ['primary, 1U bias', len(df1)]
secondary_bias = ['secondary, 10A bias', len(matching_index)]

df.to_csv(sys.argv[2])

with open(sys.argv[3], 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(primary_bias)
    writer.writerow(secondary_bias)
    # f.write('primary, 1U bias: %s' % len(df1))
    # f.write('\n secondary, 1U and 10A bias: %s' % len(matching_index))
