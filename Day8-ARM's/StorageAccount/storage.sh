az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file storage.json \
  --parameters params.json
