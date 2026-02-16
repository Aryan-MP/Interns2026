Day-9: Multi-OS ARM Template Deployment (Linux & Windows VM using Conditions)
Objective

Complete the remaining Day-8 task by creating a single ARM template that deploys:

✅ Windows VM

✅ Linux VM

✅ Based on OS type parameter

✅ Using ARM template conditions

Concept Used

ARM Template parameters

condition property

Single template → Multiple OS deployment

Step 1: Create ARM Template

Create a file:

multi-os-vm.json


Add a parameter to choose OS type:

"parameters": {
  "osType": {
    "type": "string",
    "allowedValues": [
      "Windows",
      "Linux"
    ]
  }
}

Step 2: Add Condition for Windows VM
"condition": "[equals(parameters('osType'),'Windows')]"


Use this inside Windows VM resource.

Step 3: Add Condition for Linux VM
"condition": "[equals(parameters('osType'),'Linux')]"


Use this inside Linux VM resource.

Step 4: Deploy Windows VM
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file multi-os-vm.json \
  --parameters osType=Windows

Step 5: Deploy Linux VM
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file multi-os-vm.json \
  --parameters osType=Linux

Output

If Windows → Windows VM created

If Linux → Linux VM created

Only one template used
