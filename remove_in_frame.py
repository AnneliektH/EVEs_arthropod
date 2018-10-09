# load pandas
import sys
import csv
import pandas as pd
from collections import defaultdict
import time


# load dataframe
df = pd.DataFrame.from_csv(open(sys.argv[1]))
print len(df)

# list to store index that are either unique enough or have highest evalue
results = []

# list to save those that have already been added so they can be skiped
to_be_skipped = []


toolbar_width = 40

# setup toolbar
sys.stdout.write("[%s]" % (" " * toolbar_width))
sys.stdout.flush()
sys.stdout.write("\b" * (toolbar_width+1)) # return to start of line, after '['

for i in xrange(toolbar_width):
    time.sleep(0.1) # do real work here

    # loop through data frame
    for index, row in df.iterrows():

        # check if sequence or simmilar sequence already added
        if index in to_be_skipped:
            continue

        # initialize empty simmilar dict
        simmilar = defaultdict(int)

        for index2, row2 in df.iterrows():

            # check if possition start or stop is equal and is not self.
            if index == index2:
                continue

            # check if possition start or stop is equal and is not self.
            if row[11] == row2[11]:

                # if entry is comparing to itself
                if row[7] == row2[7] and row2[8] == row[8]:
                    continue

                elif (row[7] in range(row2[7], row2[8]) or
                row2[7] in range(row[7], row[8]) or
                row[8] in range(row2[7], row2[8]) or
                row2[8] in range(row[7], row[8])):
                    # add both indexes of simmilar sequences plus their score to the dict
                    simmilar[index] = row[10]
                    simmilar[index2] = row2[10]

        # check if simmilar sequences have been found
        if len(simmilar) > 0:

            # get the max evalue from the simmilar sequences
            max_index = max(simmilar.iterkeys(), key=lambda k: simmilar[k])

            # add index with maximum evalue to results list
            results.append(max_index)


            # add checked indexs to be skipped list
            for selected_index, length in simmilar.iteritems():
                to_be_skipped.append(selected_index)

        # if seqeunce is unique add index to results
        if len(simmilar) == 0:
            results.append(index)
            to_be_skipped.append(index)

    # update the bar
    sys.stdout.write("-")
    sys.stdout.flush()

sys.stdout.write("\n")

df2 = df.loc[results]

print len(df2)

# Put the results in a new csv
df2.to_csv(sys.argv[2])
