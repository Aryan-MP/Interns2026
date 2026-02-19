to Excute the above script:

az deployment sub create \
  --location "eastus" \
  --template-file combined-role.json \
  --parameters principalId="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  role definations:

storage account read acess:

  "actions": [
  "Microsoft.Storage/storageAccounts/read",
  "Microsoft.Storage/storageAccounts/blobServices/containers/read",
  "Microsoft.Authorization/*/read"
]

Network Contributor (no delete)

"actions": [
  "Microsoft.Network/*/read",
  "Microsoft.Network/virtualNetworks/write",
  "Microsoft.Network/networkSecurityGroups/write"
],
"notActions": [
  "Microsoft.Network/virtualNetworks/delete",
  "Microsoft.Network/networkSecurityGroups/delete"
]

Key Vault Secrets Reader

"actions": [
  "Microsoft.KeyVault/vaults/read",
  "Microsoft.Authorization/*/read"
],
"dataActions": [
  "Microsoft.KeyVault/vaults/secrets/getSecret/action",
  "Microsoft.KeyVault/vaults/secrets/readMetadata/action"
]

guid() function — generates a deterministic, unique GUID based on the inputs. Using subscription().id + roleName ensures the same role always gets the same ID, making deployments idempotent.
dependsOn — always add this on the role assignment resource so it waits for the role definition to be created first.
notActions — use this to exclude specific permissions from a broad wildcard. For example, allow Microsoft.Compute/* but exclude Microsoft.Compute/virtualMachines/delete.
dataActions — required for data-plane operations like reading blob contents or Key Vault secrets. These are separate from control-plane actions.