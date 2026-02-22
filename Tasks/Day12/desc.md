# Azure Windows VM Provisioning via ARM Template

## Overview

This task involved provisioning a fully configured Windows Virtual Machine on Azure using ARM templates, with automated software installation handled through a PowerShell provisioning script delivered via the Custom Script Extension (CSE).

---

## Infrastructure

The deployment consists of three core ARM templates:

- **`storage.json`** — Creates a Storage Account with a public blob container (`scripts`) to host the provisioning script. Deployed first as a prerequisite.
- **`deploy.json`** — Deploys the full VM infrastructure: VNet, Subnet, NSG, Public IP, NIC, and the Windows VM itself. The Custom Script Extension is attached directly to the VM resource, downloading and executing `logon.ps1` from the storage account on first boot.
- **`parameters/vm.parameters.json`** — Stores deployment parameters including VM name, admin credentials, and storage account name.

**VM Specifications:** Windows Server 2022 Datacenter, Standard_B2s, Central India.

---

## Provisioning Script (`logon.ps1`)

The script runs once at deployment time as SYSTEM via the CSE. It is structured in two logical phases:

**Phase 1 — Immediate (runs during deployment):**
Installs IIS via `Install-WindowsFeature`, deploys a custom HTML welcome page to the IIS root, starts the web service, and opens port 80 on Windows Firewall.

**Phase 2 — Deferred (runs at first user logon):**
Installs Chocolatey, then uses it to install Python and VS Code system-wide. A separate extension install script is written to `C:\Users\Public\` and registered under the `HKLM RunOnce` registry key. This ensures VS Code extensions (`ms-python.python`, `ms-vscode.powershell`) are installed in the correct user profile context on first RDP login, rather than under the SYSTEM profile.

---

## Deployment Commands

**Upload provisioning script to Storage Account:**

```bash
az storage blob upload `
  --account-name <storage-account-name> `
  --container-name scripts `
  --name logon.ps1 `
  --file logon.ps1 `
  --overwrite
```

**Deploy the VM template:**

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "<resource-group-name>" `
  -TemplateFile "deploy.json" `
  -TemplateParameterFile "parameters/vm.parameters.json" `
  -Verbose
```

---

## Outcome

On successful deployment the VM exposes an IIS-hosted welcome page on port 80, and upon first RDP login, VS Code is available with the Python and PowerShell extensions automatically installed and active.