# Day 3 - Assignment

## Topic : Storage Accounts

On Day 3 of my internship at Spektra Systems, we had a session focused primarily on Azure Storage Accounts. The discussion covered performance tiers (Standard and Premium) and redundancy options including Locally Redundant Storage (LRS), Zone-Redundant Storage (ZRS), Geo-Redundant Storage (GRS), and Geo-Zone-Redundant Storage (GZRS). We explored Blob Storage including access tiers such as Hot, Cool, and Cold. Additionally, we gained an overview of Queue Storage, Table Storage, and Azure File Storage, along with a brief introduction to Microsoft Defender. The session strengthened both conceptual understanding and practical knowledge of storage configuration and security considerations in Azure.

###  Blob Storage Implementation
Created container: training-content
Uploaded:
Large media file (video)
Text/PDF file
Access Level: Private
Modified Access Tier:
Hot → Cool
Enabled Soft Delete
Deleted and successfully restored a blob
Generated Read-only SAS
Verified blob access using SAS URL
#### Concepts Applied
Access tiers (Hot, Cool, Cold)
Data lifecycle management
Secure external access using SAS
Recovery mechanisms

###  Azure File Share
Created file share: team-docs
Uploaded sample document
Understood shared storage use cases for team collaboration

### Queue Storage
Created queue: user-registration
Added 3 messages
Viewed message
Deleted one message
#### Use Case
Asynchronous communication
Decoupled application components

### Table Storage
Created table: students
Added 3 entities with:
PartitionKey
RowKey
Name
Course
#### Use Case
NoSQL structured data storage
Fast key-based lookups

### Security & Governance
Applied Private container access
Implemented SAS-based controlled access
Enabled Soft Delete for data protection
Understood LRS redundancy model

### Key Outcomes
Implemented all four Azure Storage services
Configured redundancy and performance tiers
Practiced access control mechanisms
Performed lifecycle and recovery operations
Strengthened practical understanding of Azure Storage architecture
This task provided complete hands-on exposure to storage configuration, security implementation, and operational management within Azure.
