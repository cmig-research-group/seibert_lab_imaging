# Use this function to map PDS ID numbers to MD5-hashed MRNs
# >python3 generate_pds_hash_key.py <inputfile.txt> <outputfile.txt>
# 
# inputfile.txt: Text file with 2 columns, the first being PDS IDs, the second being corresponding MRNs
#                (Just copy+paste the first 2 columns of the Key spreadsheet into a text file) 
#
# outputfile.txt: Text file with 2 colums, the first being PDS IDs, the second being corresponding MD5-hashed MRNs.
#                 - Append the contents of this file to /space/bil-syn01/1/cmig_bil/RSIData/Prostate/UCSD/PDS_MRI/pds_hash_key.txt
#                   That way we have a central PDS<->MD5 map on /space/
#                 - Add the hashed MRNs to the Key spreadsheet as well
#
# When finished, delete inputfile.txt because it contains MRNs              

import sys
import hashlib

file2read = sys.argv[1]
file2write = sys.argv[2]

with open(file2read) as file1:
    with open(file2write, "w") as file2:
        for line in file1:
            file_line = line.rstrip()
            line_list = file_line.split()

            if len(line_list) < 2:
                file2.write("Missing data" + "\t" + "Missing data" + "\n")
                continue

            pds_id = line_list[0]
            mrn = line_list[1]

            if pds_id == 'PDS':
                hashed_mrn = 'Hashed MRN'
            else:
                hashed_mrn = hashlib.md5(mrn.encode()).hexdigest()

            file2.write(pds_id + "\t" + hashed_mrn + "\n")

            print("PDS ID: " + pds_id + " mrn: " + mrn + " hashed mrn: " + hashed_mrn)

