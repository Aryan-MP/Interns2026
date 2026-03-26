# Contoso Tech Education — Azure Training Lab Guide

## Lab Overview

| Detail | Value |
|---|---|
| Client | Contoso Tech Education |
| Duration | 10 days from registration |
| Subscription | Shared Azure Subscription |
| Allowed Resources | Storage Account (Standard_LRS), Virtual Machine (Standard_B1s) |

> **Important:** You can only register once using your email. Your lab environment expires automatically 10 days after registration.

---

## Prerequisites

- A valid email address (personal or organizational)
- Web browser (Edge, Chrome, or Firefox recommended)
- Basic understanding of Azure Portal navigation

---

## Part 1 — Register and Launch the Lab

1. Open the **lab registration link** provided by your instructor.
2. Fill in your details:
   - First Name
   - Last Name
   - Email Address
   - Organization: `Contoso Tech Education`
3. Click **Submit**.
4. You will receive a confirmation email with your lab credentials.
5. Click **Launch Lab** to start your environment.
6. Wait for the deployment to complete (watch the countdown timer).
7. Once ready, note down your:
   - **Azure Username**
   - **Azure Password**
   - **Resource Group Name**
   - **Subscription ID**

---

## Part 2 — Sign in to Azure Portal

1. Open [https://portal.azure.com](https://portal.azure.com) in a new browser tab.
2. Sign in using the **Azure Username** and **Azure Password** from your lab details.
3. If prompted for MFA setup, follow the on-screen instructions.
4. Once signed in, verify you can see your **Resource Group** in the portal.

---

## Part 3 — Create a Storage Account (Standard_LRS)

1. In the Azure Portal, click **+ Create a resource**.
2. Search for **Storage account** and select it.
3. Click **Create** and fill in:

| Field | Value |
|---|---|
| Subscription | (pre-selected — shared subscription) |
| Resource Group | Select your assigned resource group |
| Storage account name | `contosostudent<yourname>` (lowercase, no spaces, globally unique) |
| Region | Same as your lab region |
| Performance | **Standard** |
| Redundancy | **LRS (Locally-redundant storage)** |

4. Click **Review + Create** → **Create**.
5. Wait for deployment to succeed.
6. Navigate to your new storage account and explore:
   - **Containers** — create a blob container named `labdata`
   - **Access keys** — view (do not share) your storage keys
   - **Properties** — note the primary endpoint URL

### Verify

- Open your storage account → **Overview** → confirm SKU shows **Standard_LRS**.

> **Warning:** Attempting to create a storage account with any other redundancy (GRS, ZRS, GZRS, Premium) will be **automatically denied** by policy.

---

## Part 4 — Create a Virtual Machine (Standard_B1s)

1. In the Azure Portal, click **+ Create a resource**.
2. Search for **Virtual machine** and select it.
3. Click **Create** → **Azure virtual machine** and fill in:

| Field | Value |
|---|---|
| Subscription | (pre-selected) |
| Resource Group | Select your assigned resource group |
| Virtual machine name | `contoso-vm-<yourname>` |
| Region | Same as your lab region |
| Image | **Ubuntu Server 22.04 LTS** or **Windows Server 2022 Datacenter** |
| Size | **Standard_B1s** (click "See all sizes" → filter by B1s) |
| Authentication | Password |
| Username | `azurestudent` |
| Password | Choose a strong password (12+ chars, upper, lower, number, special) |

4. Under **Disks** tab:
   - OS disk type: **Standard HDD** (recommended for cost savings)

5. Under **Networking** tab:
   - Leave defaults (a new vNet, subnet, and public IP will be created)

6. Click **Review + Create** → **Create**.
7. Wait for deployment to complete.

### Verify

- Go to your VM → **Overview** → confirm Size shows **Standard_B1s**.
- Note the **Public IP address** for connecting later.

> **Warning:** Attempting to create any VM size other than Standard_B1s (e.g., B2s, D2s_v3, etc.) will be **automatically denied** by policy.

---

## Part 5 — Connect to Your Virtual Machine

### If you chose Linux (Ubuntu):

1. Open a terminal (PowerShell, CMD, or your system terminal).
2. Run:
   ```
   ssh azurestudent@<your-vm-public-ip>
   ```
3. Enter your password when prompted.
4. You are now connected. Run `hostname` to verify.

### If you chose Windows Server:

1. Open **Remote Desktop Connection** (search `mstsc` in Start menu).
2. Enter your VM's **Public IP address**.
3. Click **Connect** → enter username `azurestudent` and your password.
4. You are now connected to your Windows VM.

---

## Part 6 — Explore and Experiment

Try these exercises within your allowed resources:

### Exercise A — Blob Storage Operations
1. Go to your Storage Account → **Containers** → `labdata`.
2. Click **Upload** → upload any small file (< 5 MB).
3. Click on the uploaded file → copy its URL.
4. Open the URL in a new tab (it will fail unless you set public access — this is expected).
5. Generate a **SAS token** for the blob and access it using the SAS URL.

### Exercise B — VM Management
1. Go to your VM → click **Stop** to deallocate it.
2. Wait for status to show **Stopped (deallocated)**.
   - Notice: the disk cost optimization will automatically downgrade your disk tier while stopped.
3. Click **Start** to restart the VM.
4. Reconnect via SSH or RDP and verify everything still works.

### Exercise C — Monitor Your Costs
1. Go to **Cost Management + Billing** in the Azure Portal.
2. Click **Cost analysis** → filter by your Resource Group.
3. Observe your accumulated cost.

> **Note:** If your usage reaches 70%, 90%, or 100% of the budget limit, your instructor will receive an email alert. Stay within limits.

---

## Part 7 — Clean Up (End of Lab)

Before your lab expires, clean up resources to save costs:

1. Go to your **Resource Group**.
2. Delete the VM first (this also removes the associated NIC, public IP, and disk).
3. Delete the Storage Account.
4. Verify the Resource Group is empty.

> Your environment will be **automatically deleted** when the 10-day duration expires, but early cleanup is good practice.

---

## Rules and Restrictions Summary

| Rule | Detail |
|---|---|
| Allowed VM Size | Standard_B1s only |
| Allowed Storage SKU | Standard_LRS only |
| Larger resources | Automatically blocked by Azure Policy |
| Disk cost optimization | Enabled — disks downgrade when VM is stopped |
| Budget alerts | Sent at 70%, 90%, 100% of limit |
| Lab duration | 10 days from registration |
| Registration | One-time only per email |

---

## Need Help?

- Contact your instructor via the email provided during registration.
- Refer to [Azure Documentation](https://learn.microsoft.com/en-us/azure/) for general Azure guidance.

---

*Contoso Tech Education — Azure Training Program 2026*
