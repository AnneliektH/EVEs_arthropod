#!/usr/bin/env python

# imports
import csv
import sys
import pandas as pd
import os

# Open df with all nucleotide numbers
df = pd.read_csv(open(sys.argv[1]), sep=' ', names = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'])
outfile = sys.argv[2]
species_name = os.path.basename(sys.argv[1])


# both
both = df.iloc[4]['C']

# sense
sense = df.iloc[0]['L']

# antisense
antisense = df.iloc[2]['L']

# make a list of the nucleotide biases that are significant. In order: sense, antisense, both
nucl_bias_list = [species_name, sense, antisense, both]


# put Z score of both sense and antisense in new df, with distinctive file name
with open(outfile, 'a') as f:
    wr = csv.writer(f)
    wr.writerow(nucl_bias_list)
