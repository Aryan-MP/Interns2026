az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file fileshare.main.json \
  --parameters @fileshare.param.json \
  --verbose
