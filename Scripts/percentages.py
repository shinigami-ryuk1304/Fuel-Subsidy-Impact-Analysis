# Recomputes the percentage for every answer and saves a tidy table for Power BI
import pandas as pd

df = pd.read_csv("Data/frequency_tables.csv")
df["pct"] = (100 * df["frequency"] / df.groupby("question")["frequency"].transform("sum")).round(1)
df.to_csv("Data/frequency_tables_with_pct.csv", index=False)

for q, g in df.groupby("question", sort=False):
    print(q)
    print(g[["response", "frequency", "pct"]].to_string(index=False), "\n")
