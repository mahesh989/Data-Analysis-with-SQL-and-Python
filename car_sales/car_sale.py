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




import matplotlib.pyplot as plt
import networkx as nx

# Create a directed graph
G = nx.DiGraph()

# Add nodes with attributes
G.add_node("employee", label="employee\nemployeeid (PK)\nfirstname\nlastname\ntitle")
G.add_node("customer", label="customer\ncustomerid (PK)\nsupportrepid (FK to employee.employeeid)\nfirstname\nlastname")
G.add_node("invoice", label="invoice\ninvoiceid (PK)\ncustomerid (FK to customer.customerid)")
G.add_node("invoiceline", label="invoiceline\ninvoicelineid (PK)\ninvoiceid (FK to invoice.invoiceid)\nunitprice\nquantity")

# Add edges with relationships
G.add_edge("employee", "customer", label="supportrepid")
G.add_edge("customer", "invoice", label="customerid")
G.add_edge("invoice", "invoiceline", label="invoiceid")

# Define the layout
pos = {
    "employee": (0, 1),
    "customer": (1, 1),
    "invoice": (2, 1),
    "invoiceline": (3, 1)
}

# Draw the graph
plt.figure(figsize=(12, 8))
nx.draw(G, pos, with_labels=True, labels=nx.get_node_attributes(G, 'label'), node_size=5000, node_color='lightblue', font_size=10, font_weight='bold', arrows=True, connectionstyle='arc3, rad=0.1')

# Draw edge labels
edge_labels = nx.get_edge_attributes(G, 'label')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color='red', font_size=10, font_weight='bold')

plt.title("Entity-Relationship Diagram (ERD)")
plt.show()
