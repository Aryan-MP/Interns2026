# Day 4 - Assignment

## Topic : Advanced Azure Storage Concepts

### 1. Network Security Hardening
Configured Firewall & Virtual Network rules
Set Public network access to Selected networks
Allowed access only from:
Current public IP address
Verified:
Access successful from allowed IP
Access denied after removing IP
Concepts Applied
Principle of least privilege (network level)
Restricted public exposure

### 2. Identity-Based Access (Azure AD Integration)
Disabled Shared Key Authorization
Enabled Azure AD-based authentication
Assigned RBAC role:
Storage Blob Data Contributor
Verified:
Blob upload/download via Azure Portal without storage keys
Concepts Applied
Elimination of key-based authentication
Secure identity-driven access control

### 3. Stored Access Policy + SAS Control
Created Stored Access Policy on container: training-content
Permissions: Read
Expiry: 24 hours
Generated SAS using policy
Verified blob access via SAS URL
Revoked access by modifying/deleting policy
Concepts Applied
Centralized SAS governance
Controlled and revocable external access

### 4. Lifecycle Management Policy
Created automated lifecycle rule:
Condition	Action
Not modified for 7 days	Move Hot → Cool
Not modified for 30 days	Move Cool → Archive
Applied only to training-content container
Reviewed lifecycle rule configuration
Concepts Applied
Automated cost optimization
Intelligent storage tier transition

### 5. Advanced Data Protection Features
Enabled:
Blob Soft Delete
Blob Versioning
Blob Change Feed
Performed:
Upload → Modify → Delete blob
Restored:
Previous blob version
Deleted blob
Concepts Applied
Version-based recovery
Protection against accidental deletion
Change tracking for auditing

### 6. Static Website Hosting
Enabled Static Website feature in Storage Account
Uploaded custom HTML file
Configured index document
Accessed static website
Concepts Applied
Low-cost static hosting
Blob-backed web hosting architecture

### Key Outcomes
Implemented enterprise-level storage security
Replaced key-based authentication with identity-based RBAC
Automated lifecycle-based cost optimization
Implemented versioning and recovery mechanisms
Configured network isolation
Deployed static website using Azure Storage
