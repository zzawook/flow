import csv

input_file = 'C:/Users/kjaeh/Desktop/dev/flow/be/src/main/resources/testdata/transaction_history.csv'
output_file = 'C:/Users/kjaeh/Desktop/dev/flow/be/src/main/resources/testdata/processed_transaction_history.csv'

import os
import random

if not os.path.exists(input_file):
    raise FileNotFoundError(f"The file {input_file} does not exist.")

with open(input_file, mode='r', newline='') as infile, open(output_file, mode='w', newline='') as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)
    
    for row in reader:
        transaction_status = random.choice(['PENDING', 'COMPLETE'])
        row.append(transaction_status)
        row.pop(1)
        writer.writerow(row)