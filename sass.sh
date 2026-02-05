
#!/bin/bash

# Variables
STORAGE_ACCOUNT="sdfghwer"
CONTAINER="skkk12345"
BLOB="file.txt"
SAS_TOKEN="sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-02-05T16:14:16Z&st=2026-02-05T07:59:16Z&spr=https&sig=gAN0BvPEzjZNJnT%2BnX4PCOwdgDb5QNR37jfqUtHthX0%3D"
OUTPUT_FILE="./file.txt"

# Construct full SAS URL
BLOB_URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BLOB}?${SAS_TOKEN}"

echo "Downloading ${BLOB} from container ${CONTAINER}..."

# Use curl to download
curl -o "${OUTPUT_FILE}" "${BLOB_URL}"

if [ $? -eq 0 ]; then
  echo "Download complete: ${OUTPUT_FILE}"
else
  echo "Download failed!"
fi