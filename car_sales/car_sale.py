import pandas as pd
import os

# Define the absolute file path
file_path = '/Users/mahesh/Documents/GitHub/Extraction_via_API/car_sales/autos.csv'

# Check if the file exists
if os.path.exists(file_path):
    # Read the CSV file
    df = pd.read_csv(file_path, encoding='ISO-8859-1')  # or try 'latin1'
    print("File read successfully")
    
    # Save the DataFrame to a new CSV file
    output_path = '/Users/mahesh/Documents/GitHub/Extraction_via_API/car_sales/autos_output.csv'
    df.to_csv(output_path, index=False)
    print(f"DataFrame saved to {output_path}")
else:
    print(f"File not found: {file_path}")
