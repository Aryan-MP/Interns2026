# Day 4 – Assessment & Solution  
## Advanced Azure Storage

---

## Objective
To use Azure Storage in a production-ready way by applying security, access control, cost saving rules, data protection, and static website hosting.

---

## Task 1: Storage Account Network Security (Firewall)

### What it is
Network security controls from where the Storage Account can be accessed.

### Why it is done
- To block access from unknown networks
- To protect data even if someone has login access
- Required for real production environments

### How it is done
- Opened the Storage Account
- Went to Networking settings
- Set access to selected networks
- Allowed access only from my public IP address
- Verified access works when IP is allowed and fails when IP is removed

---

## Task 2: Identity and Access Control (RBAC)

### What it is
RBAC controls who can access storage using their Azure login.

### Why it is done
- Shared keys give full access and are unsafe
- RBAC gives limited and controlled access
- Access can be tracked and audited

### How it is done
- Used Azure Active Directory authentication
- Assigned role: Storage Blob Data Contributor
- Access was based on role instead of access keys

---

## Task 3: Shared Access Signature (SAS) with Policy

### What it is
SAS provides temporary and limited access to storage resources.

### Why it is done
- To share files securely
- To avoid sharing full access keys
- To control access duration and permissions

### How it is done
- Created a stored access policy on the container
- Set permission to read-only
- Set expiry time
- Generated SAS using the policy
- Verified blob access using SAS URL
- Removed the policy and confirmed access stopped

---

## Task 4: Lifecycle Management (Cost Optimization)

### What it is
Lifecycle management automatically moves data to cheaper storage tiers.

### Why it is done
- To reduce storage cost
- To avoid manual data movement
- Important for long-term storage

### How it is done
- Created lifecycle rule:
  - After 7 days → Hot to Cool
  - After 30 days → Cool to Archive
- Applied rule only to the training-content container

---

## Task 5: Advanced Data Protection

### What it is
Data protection features help recover deleted or changed files.

### Why it is done
- To avoid data loss
- To recover from mistakes
- Important for production systems

### How it is done
- Enabled Blob Soft Delete
- Enabled Blob Versioning
- Enabled Change Feed
- Uploaded, modified, and deleted blobs
- Restored deleted blobs and older versions

---

## Task 6: Static Website Hosting

### What it is
Hosting a simple website using Azure Blob Storage.

### Why it is done
- Low cost solution
- No server required
- Useful for static websites

### How it is done
- Enabled Static Website feature
- Set index.html and 404.html
- Uploaded HTML files
- Accessed website using the storage endpoint URL

---

## Assessment Outcome
- Storage account secured using network rules and RBAC
- Safe access provided using SAS
- Cost saving rules applied using lifecycle management
- Data protection features enabled and tested
- Static website hosted successfully
- Azure Storage used in a production-ready manner
