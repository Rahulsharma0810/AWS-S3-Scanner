# What to do ?
# Create a list for integer (1, 50)
# Use that list in os.system to in loop for recurrency.

# First Download EICAR
# https://secure.eicar.org/eicar_com.zip

import os
bucketName = "Bucket_Name_where_triggers_happens"
filePath = "~/Downloads/eicarcom.zip"
keyName = "eicarcom"
keyExt = ".zip"

def createList(r1, r2):
    return [item for item in range(r1, r2+1)]

counter = createList(1, 5)

for i in counter:
    print('Copied Key : s3://' + bucketName + '/' + keyName + str(i) + keyExt )
    os.system('aws s3 cp ' + filePath + ' s3://' + bucketName + '/' + keyName + str(i) + keyExt)
