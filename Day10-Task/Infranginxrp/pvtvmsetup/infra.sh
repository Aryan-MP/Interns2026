az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file infra.json \
  --parameters param.infra.json \
  --verbose
