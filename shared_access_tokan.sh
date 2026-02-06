#!/bin/bash

STORAGE_ACCOUNT = "sdfghwer"
CONTAINER = "skkk12345"
BLOB_NAME = "pod.yaml"

SAS_TOKEN = "sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-02-05T16:14:16Z&st=2026-02-05T07:59:16Z&spr=https&sig=gAN0BvPEzjZNJnT%2BnX4PCOwdgDb5QNR37jfqUtHthX0%3D"

OUTPUT_FILE = "pod.yaml"

URL = "https://"$STORAGE_ACCOUNT".blob.core.windows.net/"$CONTAINER"/"$BLOB_NAME"/"$SAS_TOKEN"

curl -L "$URL" -o "$OUTPUT_FILE"





STORAGE_ACCOUNT="sdfghwer"
CONTAINER="skkk12345"
BLOB_NAME="pod.yaml"

SAS_TOKEN="sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-02-05T16:14:16Z&st=2026-02-05T07:59:16Z&spr=https&sig=gAN0BvPEzjZNJnT%2BnX4PCOwdgDb5QNR37jfqUtHthX0%3D"

OUTPUT_FILE="pod.yaml"

URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BLOB_NAME}?${SAS_TOKEN}"

curl -L "$URL" -o "$OUTPUT_FILE"



STORAGE_ACCOUNT="sdfghwer"
CONTAINER="skkk12345"
BLOB_NAME="pod.yaml"

SAS_TOKEN="sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2026-02-05T16:14:16Z&st=2026-02-05T07:59:16Z&spr=https&sig=gAN0BvPEzjZNJnT%2BnX4PCOwdgDb5QNR37jfqUtHthX0%3D"

OUTPUT_FILE="pod.yaml"

URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BLOB_NAME}?${SAS_TOKEN}"

curl -L "$URL" -o "$OUTPUT_FILE"
