

### Create 2 vm and add load balncer using UI and arm template


az deployment group create \
  --resource-group sumitspektra-rg \
  --template-file load-balancer.json \
  --parameters adminUsername=ubuntu \
               adminPassword='Imsk@123456789'




### GUI based
![alt text](image.png)

### ARM Templates Based
![alt text](image-2.png)