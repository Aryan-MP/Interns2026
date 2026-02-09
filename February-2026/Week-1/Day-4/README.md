# Day 4 – Advanced Azure Storage (Security, Automation & Production)

## Author
Manoj Gowda

---

## Day 4 Objective
- Move from basic storage usage to production-ready Azure Storage
- Learn advanced security, access control, and automation
- Understand cost optimization, monitoring, and recovery
- Treat Azure Storage as an enterprise data platform

---

## 1. Storage in Production Context
Day 4 focused on using Azure Storage in a **production environment**.

### Shift from Day 3
- Day 3: Learning and basic usage
- Day 4: Production-ready implementation

### New Priorities
- Security
- Controlled access
- Cost optimization
- Monitoring
- Data recovery

---

## 2. Network Security for Storage Account
Network-level protection was implemented for the Storage Account.

### Concepts Covered
- Public Network Access options:
  - Enabled from all networks (not recommended for production)
  - Selected networks (recommended)
  - Disabled

### Firewall Configuration
- Allowed access only from a specific public IP address
- Blocked access from all other IPs

### Key Understanding
- Storage accounts can be secured at the network level
- Even valid users cannot access storage if their IP is blocked

---

## 3. Identity & Access Control (Advanced)

### Shared Key Access
- Provides full access
- Difficult to audit
- Not recommended in production

### Azure AD Authorization
- Enabled identity-based access
- Used RBAC instead of access keys

### Role Used
- Storage Blob Data Contributor

### Key Understanding
- Access is based on identity, not keys
- Permissions can be audited and controlled

---

## 4. SAS (Shared Access Signature) – Advanced Usage

### Stored Access Policy
- Created at container level
- Defined:
  - Read permission
  - Expiry time (24 hours)

### Verification
- Blob accessed successfully using SAS URL

### Revocation
- Modified or deleted the stored access policy
- SAS access stopped immediately

### Key Understanding
- Stored Access Policies allow centralized control
- Safer than generating ad-hoc SAS tokens

---

## 5. Lifecycle Management (Cost Optimization)

### Purpose
- Automatically reduce storage costs
- No manual data movement required

### Lifecycle Rules Created
- If blob not modified for 7 days → Move from Hot to Cool
- If blob not modified for 30 days → Move from Cool to Archive

### Scope
- Applied only to container `training-content`

### Key Understanding
- Rules execute automatically
- Archive tier is suitable for long-term storage

---

## 6. Advanced Data Protection Features

### Features Covered
- Blob Soft Delete
- Blob Versioning
- Change Feed

### Hands-On Actions
- Uploaded a blob
- Modified the blob
- Deleted the blob
- Restored deleted blob
- Restored a previous version

### Key Understanding
- Multiple layers of protection are available
- Helps prevent data loss and accidental overwrites

---

## 7. Encryption (Enterprise Level)

### Encryption at Rest
- Enabled by default
- Data is encrypted automatically

### Encryption in Transit
- HTTPS enforced
- Secure transfer required

### Understanding
- Azure Storage meets enterprise and compliance requirements

---

## 8. Monitoring & Diagnostics (Introduced)

### Azure Monitor
- Used to track storage performance
- Helps detect failures and latency

### Metrics vs Logs
- Metrics: Performance numbers
- Logs: Detailed operational records

### Key Understanding
- Monitoring is essential in production to detect issues early

---

## 9. Disaster Recovery Concepts

### Redundancy Options
- LRS: Disk failure protection
- ZRS: Zone failure protection
- GRS: Region failure protection
- RA-GRS: Read access during regional outage

### Business Continuity Concepts
- RPO: Acceptable data loss
- RTO: Acceptable recovery time

### Understanding
- Storage design depends on business requirements

---

## 10. Static Website Hosting Using Blob Storage

### What Was Implemented
- Enabled static website feature
- Configured:
  - Index document: `index.html`
  - Error document: `404.html`

### Hands-On
- Uploaded HTML files
- Accessed website using storage endpoint URL

### Understanding
- Low-cost hosting for static websites
- No backend server required

---

## 11. Day 4 Hands-On Work Summary
- Secured storage account using firewall rules
- Restricted access to selected networks
- Disabled shared key access
- Enabled Azure AD authorization with RBAC
- Created Stored Access Policy and SAS
- Implemented lifecycle management rules
- Enabled advanced data protection features
- Restored deleted and overwritten blobs
- Hosted a static website using Blob Storage

---

## 12. Day 4 Outcome
After completing Day 4, the following outcomes were achieved:
- Secured Azure Storage at network and identity level
- Controlled access using RBAC and SAS
- Automated cost optimization
- Implemented data protection and recovery mechanisms
- Gained exposure to monitoring and disaster recovery concepts
- Used Azure Storage in production-ready scenarios
