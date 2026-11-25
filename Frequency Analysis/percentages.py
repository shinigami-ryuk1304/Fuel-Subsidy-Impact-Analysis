import pandas as pd

# Define a function to fetch the frequency tables from SQL Server
def fetch_data_from_sql():
    import pyodbc  # only needed when reading from SQL Server
    conn_str = (
        "Driver={SQL Server};"
        "Server=localhost\\SQLEXPRESS;"  # Change this to your own SQL Server instance
        "Database=IwayaFuelSurveyDB;"
        "Trusted_Connection=yes;"
    )
    conn = pyodbc.connect(conn_str)
    df = pd.read_sql("SELECT section, question, response, frequency FROM dbo.frequency_tables", conn)
    conn.close()
    return df

# If SQL Server is not available, read the same data from the CSV
try:
    tables = fetch_data_from_sql()
except Exception:
    tables = pd.read_csv("../Data/frequency_tables.csv")

# Percentage of people giving each answer, within each question
tables["percentage"] = (100 * tables["frequency"] / tables.groupby("question")["frequency"].transform("sum")).round(1)

# Print each question as a small table
for question, rows in tables.groupby("question", sort=False):
    print(question)
    print(rows[["response", "frequency", "percentage"]].to_string(index=False))
    print()

# Save the result for Power BI
tables.to_csv("frequency_tables_with_percentages.csv", index=False)
