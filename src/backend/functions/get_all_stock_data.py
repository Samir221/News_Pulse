import requests
import pandas as pd

# API endpoint
url = "https://financialmodelingprep.com/api/v3/available-traded/list?apikey=728883d73a69cfac83c4ba8b7d10f076"

# Send a request to the API
response = requests.get(url)

# Convert the response to JSON
data = response.json()

# Load the data into a pandas DataFrame
df = pd.DataFrame(data)

df = df[df['exchangeShortName'].isin(['NYSE', 'NASDAQ'])]
df = df[df['type'] == 'stock']
df = df[~df['symbol'].str.contains('-')]
df = df[~((df['symbol'].str.len() > 4) & df['symbol'].str[-1].isin(['U', 'W']))].reset_index(drop=True)


# Print the DataFrame
df.to_csv(r"C:\Users\samir\OneDrive\Desktop\News Stock Relevance Project\all_stocks.csv", index=False)
