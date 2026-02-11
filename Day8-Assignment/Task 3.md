# Day 8 -Assignment

### Task - 3 : Using ARM templates create Azure Container Registry (ACR) and Azure Container Instance (ACI)


{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "type": "string",
      "defaultValue": "eastus"
    }
  },
  "variables": {
    "acrName": "[toLower(concat('nikhilacr', uniqueString(resourceGroup().id)))]",
    "aciName": "nikhilContainerGroup"
  },
  "resources": [

    {
      "type": "Microsoft.ContainerRegistry/registries",
      "apiVersion": "2023-01-01-preview",
      "name": "[variables('acrName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "Basic"
      },
      "properties": {
        "adminUserEnabled": true
      }
    },

    {
      "type": "Microsoft.ContainerInstance/containerGroups",
      "apiVersion": "2023-05-01",
      "name": "[variables('aciName')]",
      "location": "[parameters('location')]",
      "properties": {
        "containers": [
          {
            "name": "nginx",
            "properties": {
              "image": "nginx",
              "ports": [
                {
                  "port": 80
                }
              ],
              "resources": {
                "requests": {
                  "cpu": 0.5,
                  "memoryInGB": 1.0
                }
              }
            }
          }
        ],
        "osType": "Linux",
        "ipAddress": {
          "type": "Public",
          "ports": [
            {
              "protocol": "TCP",
              "port": 80
            }
          ]
        },
        "restartPolicy": "Always"
      }
    }

  ],
  "outputs": {
    "acrName": {
      "type": "string",
      "value": "[variables('acrName')]"
    },
    "aciPublicIP": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.ContainerInstance/containerGroups', variables('aciName'))).ipAddress.ip]"
    }
  }
}


<img width="1919" height="504" alt="Screenshot 2026-02-11 184533" src="https://github.com/user-attachments/assets/38e3fe57-c635-492c-9c97-2aa939e2c547" />


<img width="1920" height="935" alt="Screenshot 2026-02-11 184323" src="https://github.com/user-attachments/assets/4cc82da5-1e53-4cf1-96cc-57fd2ed02a23" />
