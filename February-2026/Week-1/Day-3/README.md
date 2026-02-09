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
- Azure Storage is a cloud service used to store data
- Common use cases include storing:
  - Files
  - Media
  - Messages
  - Metadata

### Key Idea
Azure Storage is **scalable**, **durable**, and **highly available**

---

## 2. Storage Account (Foundation)
- A Storage Account is the base container for all Azure storage services
- Required to use:
  - Blob Storage
  - File Share
  - Queue Storage
  - Table Storage

### Key Understanding
- Storage services cannot be used without a Storage Account

---

## 3. Storage Account Creation (Hands-On)

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
- LRS keeps **3 copies** of data
- Data is stored within the same datacenter
- Cost-effective redundancy option

---

## 4. Storage Account Sections Explained

### Tabs Introduced
- Basics
- Advanced
- Networking
- Data Protection
- Encryption
- Tags
- Review + Create

### Purpose
To understand where networking, security, and data protection settings are configured

---

## 5. Blob Storage (Hands-On)

### What Blob Storage is Used For
- Unstructured data such as:
  - Images
  - Videos
  - PDFs
  - Text files

### Blob Container Creation
- Container name: `training-content`
- Access level: **Private**

### Understanding
- Container = Folder  
- Blob = File  

### Blob Upload
- Uploaded:
  - One text or PDF file
  - One large or media file

---

## 6. Azure File Share (Hands-On)

### What File Share Is
- Cloud-based shared folder
- Works similar to a network drive
- Uses SMB protocol

### File Share Creation
- File share name: `team-docs`
- Uploaded one document (txt / pdf / docx)

### Use Case Understanding
- Sharing files between VMs or users

---

## 7. Queue Storage (Hands-On)

### What Queue Storage Is
- Message-based storage
- Used for asynchronous communication

### Queue Creation
- Queue name: `user-registration`
- Added at least 3 messages
- Viewed one message
- Deleted one message

### Understanding
- Used for background processing

---

## 8. Table Storage (Hands-On)

### What Table Storage Is
- NoSQL key-value storage
- Schema-less
- Fast and scalable

### Table Creation
- Table name: `students`
- Added 3 entities

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
- Hot
- Cool
- Archive

### Understanding
- Used for cost optimization
- Selected based on data access frequency

---

## 10. Data Protection (Basic Level)

### Soft Delete
- Enabled for Blob Storage
- Protects against accidental deletion

### Hands-On
- Deleted one blob
- Restored the deleted blob

---

## 11. Shared Access Signature (SAS)

### What SAS Is
- Secure, temporary access to storage resources
- Time-bound with limited permissions

### Hands-On
- Generated SAS for one blob
- Permission set to read-only
- Accessed blob using SAS URL

### Understanding
- Safer than sharing storage account keys

---

## 12. Day 3 Hands-On Work Done (Summary)
- Created Storage Account with LRS
- Created Blob container and uploaded files
- Created File Share and uploaded document
- Created Queue and managed messages
- Created Table and added entities
- Enabled Soft Delete and recovered deleted data
- Generated SAS and verified secure access
- Changed Blob access tier (Hot → Cool)

---

## 13. Day 3 Outcome
After completing Day 3, I was able to:
- Understand all core Azure storage services
- Decide which storage service to use based on requirements
- Secure data using basic protection features
- Perform real hands-on storage operations
- Design storage for a simple application

---

## Day 3 – Assessment

### Task
Create an **Azure Storage Account** with **LRS (Locally Redundant Storage)** redundancy and complete hands-on tasks with all core storage services.

---

## Challenge – Azure Storage Account

### Objective
Create and use an **Azure Storage Account** to understand:
- Blob Storage
- File Share
- Queue Storage
- Table Storage

---

### Scenario
You are working on an online learning platform that requires different storage solutions for:
- Content
- Documents
- Messages
- Metadata

---

## Tasks Performed

### Task 1: Storage Account Creation
- Performance: Standard
- Redundancy: LRS
- Noted:
  - Storage account name
  - Region
  - Replication type

---

### Task 2: Blob Storage
- Created container: `training-content`
- Uploaded:
  - One video or large file
  - One PDF or text file
- Access level set to **Private**

---

### Task 3: File Share
- Created file share: `team-docs`
- Uploaded one document

---

### Task 4: Queue Storage
- Created queue: `user-registration`
- Added 3 messages
- Viewed and deleted one message

---

### Task 5: Table Storage
- Created table: `students`
- Added 3 entities with:
  - PartitionKey
  - RowKey
  - Name
  - Course

---

### Task 6: Blob Soft Delete & Recovery
- Enabled Soft Delete
- Deleted one blob
- Restored the deleted blob

---

### Task 7: Access Control Using SAS
- Generated read-only SAS for one blob
- Verified access using SAS URL

---

### Task 8: Blob Storage Access Tiers
- Changed access tier from Hot to Cool
- Observed usage scenarios for Hot, Cool, and Archive tiers
