# Lab: Create an Azure Storage Account

## Objective
Create a Storage Account in Azure using the Portal.

---

## Prerequisites
- Azure Subscription access
- Contributor or Owner role on the Resource Group

---

## Steps

### 1. Navigate to Storage Accounts
- Go to **Azure Portal**
- Search for **Storage Accounts**
- Click **+ Create**

---

### 2. Basics Tab
- **Subscription**: Select your subscription  
- **Resource Group**: Create new or select existing  
- **Storage Account Name**: Must be globally unique (e.g., mystoragelab123)  
- **Region**: Select same region as your lab  
- **Performance**: Standard  
- **Redundancy**: LRS (Locally Redundant Storage)  

Click **Next: Advanced** (leave defaults) → **Review + Create**

---

### 3. Create
- Click **Create**
- Wait for deployment to complete
- Click **Go to resource**

---

## Validation
- Confirm the Storage Account is in **Succeeded** state
- Verify you can see:
  - Containers
  - File shares
  - Queues
  - Tables

---

## Success Criteria
✔ Storage Account deployed  
✔ Accessible from Azure Portal  
✔ No deployment errors