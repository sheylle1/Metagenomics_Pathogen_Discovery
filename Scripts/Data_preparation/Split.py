import re

# Define input and output file paths
input_file = "D:/UMoya/Kraken_h/Ks1.txt"
bacteria_output_file = "bacteria_report.txt"
viruses_output_file = "viruses_report.txt"

# Initialize tracking variables
is_bacteria_section = False
is_virus_section = False

# Open input and output files
with open(input_file, "r") as infile, \
        open(bacteria_output_file, "w") as bacteria_file, \
        open(viruses_output_file, "w") as viruses_file:

    for line in infile:
        if re.search(r"\bBacteria\b", line):
            is_bacteria_section = True
            is_virus_section = False
            bacteria_file.write(line)        
        elif re.search(r"\bViruses\b", line):
            is_virus_section = True
            is_bacteria_section = False
            viruses_file.write(line)
        elif re.search(r"\bArchaea\b", line) and is_bacteria_section:
            is_bacteria_section = False
        elif is_bacteria_section:
            bacteria_file.write(line)      
        elif is_virus_section:
            viruses_file.write(line)

print("Splitting complete. Check bacteria_report.txt and viruses_report.txt for results.")
