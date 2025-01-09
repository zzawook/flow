import csv

input_file = '/home/kjaehyeok21/dev/flow/be/src/main/resources/testdata/transaction_history.csv'
output_file = '/home/kjaehyeok21/dev/flow/be/src/main/resources/testdata/processed_transaction_history.csv'

import os
import random

if not os.path.exists(input_file):
    raise FileNotFoundError(f"The file {input_file} does not exist.")

with open(input_file, mode='r', newline='') as infile, open(output_file, mode='w', newline='') as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)
    
    for row in reader:
        # Convert card_id (4th column) from decimal to integer if necessary
        try:
            row[3] = int(float(row[3]))
        except ValueError:
            pass
        
        writer.writerow(row)