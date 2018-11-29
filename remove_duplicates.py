#Anneliekter ter Horst, 2017

# load pandas
import pandas as pd
import sys

# load dataframe
df = pd.DataFrame.from_csv(sys.argv[1])

# sort on postion query start to keep highest later on
df.sort_values('position_on_query_start', inplace=True)

# drop duplicates based on start and direction keep first so highest
df.drop_duplicates(["direction", "position_on_query_start"], inplace=True, keep="first")

# sort on postion query stop to keep highest later on
df.sort_values("position_on_query_stop", inplace=True)

# drop duplicates based on stop and direction keep first so highest
df.drop_duplicates(["direction", "position_on_query_stop"], inplace=True, keep="first")

print len(df)

# show dataframe
df.to_csv(sys.argv[2])
