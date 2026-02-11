Day 8 -Assignment

Task - 3






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


