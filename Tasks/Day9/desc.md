# ARM Template — Flexible VM Deployment (Multi-OS + Conditional Configuration)

## Overview

This task implemented a reusable ARM template to provision Azure Virtual Machines with **flexible OS selection** and **conditional post-deployment configuration**. The design supports both simple and advanced scenarios through parameter-driven logic and extension-based automation.

---

## Task 1 — Dual OS Deployment with Boolean Configuration

- Built a parameterized ARM template to deploy either **Ubuntu (Linux)** or **Windows Server** VM.
- Used an **OS selector parameter** to switch image reference dynamically at deployment time.
- Implemented a **boolean condition check** to control which VM extension runs.
- Applied OS-specific post-deployment configuration:
  - Linux → Custom Script Extension installs and enables Nginx.
  - Windows → Custom Script Extension installs and configures IIS.
- Used conditional resource blocks so only the relevant extension is deployed.
- Ensured naming constraints (Windows computer name ≤ 15 chars) using computed VM resource name logic.
- Automated network stack provisioning:
  - VNet, Subnet, NSG, Public IP, NIC.
- Opened required ports (SSH, RDP, HTTP, HTTPS) through NSG rules.

---

## Task 2 — Multi-OS Flexible Deployment via Parameters

- Extended template to support **multiple Linux distributions + Windows**:
  - Ubuntu, Windows, Red Hat, Debian, CentOS, SUSE.
- Implemented a **parameter-driven OS catalog** using a lookup map for image references.
- Enabled OS selection entirely through the **parameters file** — no template edits required.
- Mapped each OS type to:
  - Correct publisher / offer / SKU
  - Correct bootstrap install script.
- Used conditional logic to select:
  - Linux vs Windows extension publisher/type.
- Result: single template supports multiple OS targets with runtime selection.

---

## Design Highlights

- Fully parameterized infrastructure deployment.
- Conditional extensions using ARM `condition` expressions.
- Image selection via variable lookup table.
- Script-based web server bootstrap per OS.
- Reusable, environment-agnostic template structure.
- Incremental deployment safe for redeployments.
- Validation-first workflow before provisioning.

---

## Deployment Commands

```bash
# validate template
az deployment group validate \
  --resource-group <rg-name> \
  --template-file <template.json> \
  --parameters <parameters.json>

# deploy template
az deployment group create \
  --resource-group <rg-name> \
  --template-file <template.json> \
  --parameters <parameters.json>

# list VMs
az vm list -g <rg-name> -o table

# get public IP
az vm show -d -g <rg-name> -n <vm-name> --query publicIps -o tsv

# check extensions
az vm extension list -g <rg-name> --vm-name <vm-name> -o table
```