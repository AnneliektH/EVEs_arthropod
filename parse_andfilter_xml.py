"""
Script that filters the blast xml file on certain parameters, filters
out the doubles and converts it to a xml file
Anneliek ter Horst
10/7/17
"""

# imports
from __future__ import division
from Bio.Blast import NCBIXML
import csv
import sys
from lxml import etree
import pandas as pd



# Open the result file from BLAST
result = NCBIXML.parse(open(sys.argv[1]))

# Open the outputfile
output = sys.argv[2]

# Write a header for the outputfile
header = ('sequence', 'length', 'perc_identity', 'gaps', 'frame', 'position_on_hit_start',
          'position_on_hit_stop', 'position_on_query_start', 'position_on_query_stop', 'evalue', 'score',  'direction')

# open the outputfile
with open(output,'w') as f:
  writer = csv.writer(f)
  writer.writerow(header)

  # Go into fasta records
  for record in result:

    # Go into fasta alignments
    if record.alignments:

      # Check each alignment
      for alignment in record.alignments:

        # Check if "virus" is word that is present in title
        # And not retro/baculo or braco
        if ('virus' in alignment.title.lower() and 'retro' not in alignment.title.lower()
        and 'baculo' not in alignment.title.lower() and 'braco' not in alignment.title.lower()
        and 'nucleopolyhedrovirus' not in alignment.title.lower() and 'immunodeficiency' not in alignment.title.lower()
        and 'foamy' not in alignment.title.lower() and len(alignment.title) < 2000 and 'granulo' not in alignment.title.lower()):

          # Make recognizable names for all xml input objects.
          for hsp in alignment.hsps:
            sequence = alignment.title
            length = hsp.align_length
            perc_identity = float((hsp.identities/hsp.align_length)*100)
            gaps = hsp.gaps
            query_frame = hsp.frame
            direction = record.query

            # Hit is viral hit from viral database
            position_on_hit_start = hsp.sbjct_start
            position_on_hit_stop = hsp.sbjct_end

            # Query is piRNA cluster of insect
            position_on_query_start = hsp.query_start
            position_on_query_stop = hsp.query_end
            evalue = hsp.expect
            score = hsp.score

            # Write to csv
            row = (sequence, length, perc_identity, gaps, query_frame[0],
            position_on_hit_start, position_on_hit_stop ,position_on_query_start,
            position_on_query_stop, evalue, score, direction)
            writer.writerow(row)

  # close the file
  f.close()
  result.close()

# open the dataframe
df = pd.DataFrame.from_csv(open(sys.argv[2])).reset_index()
# print len(df)

# max eval on position_on_query_start is equal
max_eval = df.groupby(['sequence', 'position_on_query_start']).evalue.transform(max)
df4 = df[df.evalue == max_eval]

# max eval on position_on_query_stop is equal
max_eval = df.groupby(['sequence', 'position_on_query_stop']).evalue.transform(max)
df5 = df[df.evalue == max_eval]

# merge both max tables
df = df4.append(df5)

# and remove where start sequence is equal
df = df.drop_duplicates(['sequence', 'position_on_query_start'])

# remove where stop sequence is equal
df = df.drop_duplicates(['sequence', 'position_on_query_stop'])

#remove where stop and start are equal
df = df.drop_duplicates([ 'sequence', 'position_on_query_start', 'position_on_query_stop'])


# output to csv
df.to_csv(sys.argv[2])

result.close()
