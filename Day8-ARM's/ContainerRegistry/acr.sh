az deployment group create \
  --resource-group your-rg-name \
  --template-file acr.json \
  --parameters param.acr.json
