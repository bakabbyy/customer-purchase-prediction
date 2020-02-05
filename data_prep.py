import pandas as pd

# read in both csv files as dataframes
df1 = pd.read_csv('data/2019-Oct.csv')
df2 = pd.read_csv('data/2019-Nov.csv')

# combine the dataframes
df = df1.append(df2, ignore_index=True)

# export the dataframe without index or header to be uploaded into local
# database and AWS Postgres instance
df.to_csv('all_data.csv', index=False, header=False)
