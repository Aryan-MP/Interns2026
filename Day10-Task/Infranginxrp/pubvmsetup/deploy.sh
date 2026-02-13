az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file pubvm.json \
  --parameters param.pubvm.json \
  --verbose
