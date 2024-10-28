# Define input and output file paths
input_file = "D:/UMoya/Kraken_h/Ks1.txt"
species_output_file = "species_only_report.txt"

with open(input_file, "r") as infile, open(species_output_file, "w") as outfile:
    # Iterate over each line in the input file
    for line in infile:
        columns = line.split("\t")

        if len(columns) > 4 and columns[3].strip() == "S":
            # Write the line to the output file if Rank is "S"
            outfile.write(line)

print("Filtering complete. Check species_only_report.txt for results.")
