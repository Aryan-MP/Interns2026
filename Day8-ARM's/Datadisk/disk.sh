az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file disk.json \
  --parameters params.json
