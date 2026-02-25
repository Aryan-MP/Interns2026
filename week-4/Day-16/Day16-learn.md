To define and use **Azure Compute Gallery** (to store VM images) in an ARM template, you deploy these resource types:

* `Microsoft.Compute/galleries`
* `Microsoft.Compute/galleries/images`
* `Microsoft.Compute/galleries/images/versions`

Below is a simple example.

---

## 1️⃣ Create Azure Compute Gallery

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Compute/galleries",
      "apiVersion": "2022-03-03",
      "name": "myComputeGallery",
      "location": "[resourceGroup().location]",
      "properties": {
        "description": "Gallery for storing VM images"
      }
    }
  ]
}
```

---

## 2️⃣ Create Image Definition Inside Gallery

This defines the OS type and VM generation.

```json
{
  "type": "Microsoft.Compute/galleries/images",
  "apiVersion": "2022-03-03",
  "name": "myComputeGallery/myImageDefinition",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[resourceId('Microsoft.Compute/galleries', 'myComputeGallery')]"
  ],
  "properties": {
    "osType": "Linux",
    "osState": "Generalized",
    "hyperVGeneration": "V2",
    "publisher": "myPublisher",
    "offer": "myOffer",
    "sku": "mySku"
  }
}
```

---

## 3️⃣ Create Image Version (From Existing VM )

This version points to a source managed image.

```json
{
  "type": "Microsoft.Compute/galleries/images/versions",
  "apiVersion": "2022-03-03",
  "name": "myComputeGallery/myImageDefinition/1.0.0",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[resourceId('Microsoft.Compute/galleries/images', 'myComputeGallery', 'myImageDefinition')]"
  ],
  "properties": {
    "publishingProfile": {
      "targetRegions": [
        {
          "name": "eastus",
          "regionalReplicaCount": 1
        }
      ]
    },
    "storageProfile": {
      "source": {
        "id": "/subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.Compute/images/myManagedImage"
      }
    }
  }
}
```

---

# 🔹 Key Points

* `galleries` → container
* `images` → image definition (OS type, offer, SKU)
* `versions` → actual deployable image
* Version format must follow semantic versioning (e.g., `1.0.0`)
* Source can be:

  * Managed Image
  * Snapshot
  * VM

---
