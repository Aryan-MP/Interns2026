# Day 4 – Advanced Azure Storage Concepts (Assessment)

## Task
Design, secure, and optimize an **Azure Storage Account** using advanced storage features including **network security, identity-based access, lifecycle management, monitoring, and disaster recovery concepts**.

---

## Challenge – Advanced Azure Storage Account

## Objective
Understand and implement **enterprise-grade Azure Storage Account features**, focusing on:

- Network security  
- Identity & access control  
- Data protection & lifecycle  
- Monitoring & diagnostics  
- Cost optimization  
- High availability & recovery concepts  

---

## Scenario
Your online learning platform is now in **production**.  
It stores **sensitive student data**, **large media files**, and **system messages**.

Security, cost, monitoring, and recoverability are now **critical requirements**.

You must enhance your **existing Storage Account** (or create a new one) using **advanced Azure Storage features**.

---

## Tasks

---

## Task 1: Secure Network Access to Storage Account

- Open **Storage Account → Networking**
- Configure **Firewalls and Virtual Networks**
- Set **Public network access** to **Selected networks**
- Allow access only from:
  - Your current public IP
- Verify:
  - Access works from the allowed IP
  - Access fails when the IP is removed

---

## Task 2: Disable Shared Key Access & Use Azure AD

- Open **Storage Account → Configuration**
- Disable **Shared key access**
- Enable **Azure AD authorization** (where applicable)
- Assign yourself the role:
  - **Storage Blob Data Contributor**
- Verify:
  - You can upload and download blobs using the Azure Portal

---

## Task 3: Stored Access Policy + SAS

- Open the **training-content** container
- Create a **Stored Access Policy**
- Configure the policy:
  - Permissions: **Read**
  - Expiry: **24 hours**
- Generate a **SAS token** using this policy
- Verify:
  - The blob is accessible via the SAS URL
- Revoke access by:
  - Modifying or deleting the stored access policy

---

## Task 4: Lifecycle Management Policy

- Open **Lifecycle Management**
- Create a new rule with the following conditions:
  - If a blob has not been modified for **7 days**
    - Move from **Hot** to **Cool**
  - If a blob has not been modified for **30 days**
    - Move from **Cool** to **Archive**
- Apply the rule only to:
  - Container: **training-content**
- Review the rule simulation (if available)

---

## Task 5: Enable Advanced Data Protection

- Open **Storage Account → Data Protection**
- Enable:
  - **Blob Soft Delete**
  - **Blob Versioning**
  - **Blob Change Feed**
- Perform the following actions:
  - Upload a blob
  - Modify the blob
  - Delete the blob
- Restore:
  - A previous blob version
  - A deleted blob

---
