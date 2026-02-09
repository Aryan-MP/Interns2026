# Day 3 – Azure Storage (Basics to Hands-On)

## Author
Manoj Gowda

---

## Day 3 Objective
- Understand Azure Storage services
- Learn why different storage types exist
- Create and use an Azure Storage Account
- Perform hands-on tasks with core storage services
- Understand basic security and data protection features

---

## 1. Introduction to Azure Storage
Azure Storage is a cloud service used to store different types of data such as:
- Files
- Media
- Messages
- Metadata

### Key Idea
Azure Storage is **scalable**, **durable**, and **highly available**, making it suitable for cloud applications.

---

## 2. Storage Account (Foundation)
A Storage Account is the **base container** required to use all Azure storage services.

### Storage Services Covered
- Blob Storage
- File Share
- Queue Storage
- Table Storage

### Key Understanding
- Storage services cannot be used without a Storage Account
- All data is stored inside a Storage Account

---

## 3. Storage Account Creation (Hands-On)
During the session, the process of creating a Storage Account was explained and demonstrated.

### Configuration Learned
- Subscription
- Resource Group
- Storage Account Name  
  - Must be globally unique  
  - Only lowercase letters and numbers allowed
- Region
- Performance: Standard
- Redundancy: LRS (Locally Redundant Storage)

### Redundancy Understanding
- LRS maintains **three copies** of data
- Data is stored within the same datacenter
- It is a low-cost redundancy option suitable for learning environments

---

## 4. Storage Account Sections Explained
The following sections (tabs) were introduced during Storage Account creation:

- Basics
- Advanced
- Networking
- Data Protection
- Encryption
- Tags
- Review + Create

### Purpose
To understand where storage-related security, networking, and data protection settings are configured.

---

## 5. Blob Storage (Hands-On)
Blob Storage is used to store **unstructured data** such as:
- Images
- Videos
- PDFs
- Text files

### Blob Container Creation
- Container name: `training-content`
- Access level set to **Private**

### Key Understanding
- Container works like a **folder**
- Blob works like a **file**

### Blob Upload
- One text or PDF file uploaded
- One large or media file uploaded

---

## 6. Azure File Share (Hands-On)
Azure File Share is a cloud-based shared folder that works like a network drive.

### Key Points
- Uses the SMB protocol
- Allows file sharing between users or virtual machines

### File Share Creation
- File share name: `team-docs`
- One document (txt / pdf / docx) uploaded

---

## 7. Queue Storage (Hands-On)
Queue Storage is used for **message-based** and **asynchronous communication**.

### Queue Creation
- Queue name: `user-registration`
- Added at least three messages
- Viewed one message
- Deleted one message

### Understanding
- Commonly used for background processing and event handling

---

## 8. Table Storage (Hands-On)
Table Storage is a **NoSQL key-value storage** service.

### Key Characteristics
- Schema-less
- Fast and scalable

### Table Creation
- Table name: `students`
- Added three entities

### Fields Used
- PartitionKey
- RowKey
- Name
- Course

### Understanding
- PartitionKey groups related data
- RowKey uniquely identifies a record

---

## 9. Blob Access Tiers (Introduced)
The following Blob access tiers were explained:
- Hot
- Cool
- Archive

### Understanding
- Access tiers help optimize storage cost
- Selection depends on how frequently data is accessed

---

## 10. Data Protection (Basic Level)
Basic data protection features were introduced.

### Soft Delete
- Enabled for Blob Storage
- Protects data from accidental deletion

### Hands-On
- Deleted a blob
- Restored the deleted blob using Soft Delete

---

## 11. Shared Access Signature (SAS)
Shared Access Signature (SAS) provides **secure and temporary access** to storage resources.

### Key Points
- Time-bound access
- Limited permissions

### Hands-On
- Generated a SAS for one blob
- Set permission to read-only
- Accessed the blob using the SAS URL

### Understanding
- SAS is safer than sharing storage account keys

---

## 12. Day 3 Hands-On Work Summary
- Created Storage Account with LRS
- Created Blob container and uploaded files
- Created File Share and uploaded document
- Created Queue and managed messages
- Created Table and added entities
- Enabled Soft Delete and recovered deleted data
- Generated SAS and verified secure access
- Changed Blob access tier from Hot to Cool

---

## 13. Day 3 Outcome
After completing Day 3, the following outcomes were achieved:
- Clear understanding of all core Azure Storage services
- Ability to decide which storage service to use based on requirements
- Knowledge of basic data security and protection features
- Hands-on experience with real Azure storage operations
- Ability to design storage for a simple cloud application


