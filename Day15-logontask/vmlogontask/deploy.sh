az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file logonvm.jsonc \
  --parameters param.jsonc \
  --verbose