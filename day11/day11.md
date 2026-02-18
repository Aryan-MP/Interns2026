# ☁️ Azure Nested Virtualization Auto-Deployer

A "Zero-Touch", self-healing PowerShell automation script that deploys a Hyper-V Host VM in Azure, survives the mandatory Hypervisor installation reboot, and automatically provisions a nested Guest VM.

## 🚀 Features
* **Nuclear Clean:** Automatically purges old resources in the target Resource Group for a clean deployment.
* **Syntax Shield:** Uses Base64 encoding to inject complex PowerShell logic into the ARM Template, preventing JSON parsing errors.
* **Self-Healing Reboot:** Utilizes Windows Scheduled Tasks (`AtStartup`, `SYSTEM` privileges) to persist the deployment state across the mandatory Hyper-V restart.
* **Zero-Touch Verification:** The local script polls the Azure VM post-reboot and automatically retrieves the final success report containing the nested VM's vital signs.

## 📋 Prerequisites
1. [Az PowerShell Module](https://learn.microsoft.com/en-us/powershell/azure/install-az-ps) installed and authenticated (`Connect-AzAccount`).
2. An Azure Subscription with sufficient vCPU quota for a `Standard_D4s_v3` VM (required for hardware VT-x pass-through).

## 🛠️ Usage
1. Clone this repository.
2. Open PowerShell and navigate to the directory.
3. Run the script:
   ```powershell
   .\Deploy-NestedVM.ps1