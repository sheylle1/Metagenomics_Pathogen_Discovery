
input_file = "KrakenFile.txt"
tax_list_file = "Tax_List.txt"
filtered_output_file = "data/filtered_report.txt"

# Load taxonomy IDs from Tax_List.txt into a set for fast lookup
with open(tax_list_file, "r") as tax_file:
    tax_ids = {line.strip() for line in tax_file}

# Open the Kraken report file and output file
with open(input_file, "r") as infile, open(filtered_output_file, "w") as outfile:
    # Iterate over each line in the input file
    for line in infile:
        # Split the line by tabs to access individual columns
        columns = line.split("\t")
        if len(columns) > 4 and columns[4].strip() in tax_ids:
            # Write the line to the output file if the Taxonomy ID matches
            outfile.write(line)

print("Filtering complete. Check filtered_report.txt for results.")
