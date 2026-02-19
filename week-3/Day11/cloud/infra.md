
az deployment group create \
  --resource-group sumitspektra-rg \
  --template-file infra.json \
  --parameters adminPassword='Imsk@123456789'


Standard_DC1ds_v3



SSH into VM and run:

virsh list --all

sudo virsh console nestedvm

sudo virsh domifaddr nestedvm

