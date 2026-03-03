```markdown id="a9xk2m"

# Day 4 – Deploy Windows VM with Custom Script Extension (CSE) and Logon Automation

**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 4 was to deploy a Windows Virtual Machine using an ARM Template and automate post-deployment configuration using the Azure Custom Script Extension (CSE).

The lab focused on:

- Deploying a Windows VM using Infrastructure as Code (ARM Template)
- Configuring Custom Script Extension (CSE)
- Creating a Task Scheduler entry
- Executing a script automatically at user logon

This session demonstrated enterprise-grade VM provisioning and automation practices.

---

# 2. Problem Statement

In enterprise environments, newly provisioned machines often require:

- Software installation
- Developer tools configuration
- Policy enforcement
- Environment setup

Manually configuring each machine is inefficient and error-prone.

Solution:  
Use ARM Template + Custom Script Extension + Logon Trigger automation.

---

# 3. Architecture Flow

```

ARM Template Deployment
↓
Windows VM Provisioned
↓
Custom Script Extension Executes
↓
Task Scheduler Entry Created
↓
User Logs In
↓
Script Runs Automatically

```

This separates infrastructure provisioning from user-context configuration.

---

# 4. Core Technologies Used

## 4.1 ARM Template (Infrastructure as Code)

ARM Template was used to define:

- Virtual Network
- Network Security Group
- Public IP
- Network Interface
- Windows VM
- Custom Script Extension

Benefits:

- Repeatable deployments
- Version-controlled infrastructure
- Reduced manual configuration
- Automated provisioning

---

## 4.2 Custom Script Extension (CSE)

Azure Custom Script Extension allows:

- Downloading scripts from URI
- Executing PowerShell inside VM
- Performing post-provisioning tasks
- Automating configuration steps

CSE runs after the VM is successfully created.

---

## 4.3 Windows Task Scheduler

Task Scheduler was configured to:

- Trigger at user logon
- Execute script automatically
- Run with required privileges

This ensures configuration occurs in the correct user context.

---

# 5. Why Use Logon Trigger Instead of Direct Script Execution?

Direct execution during provisioning runs under SYSTEM account.

Some installations require:

- User profile loaded
- GUI session
- User-level registry access
- Per-user application configuration

Using "At Logon" trigger ensures:

- Script runs when user signs in
- Applications install properly
- User environment is fully available

---

# 6. Enterprise Use Case

In real enterprise scenarios, this approach is used to:

- Automatically install software when employee logs in
- Configure development environments
- Enforce machine configuration standards
- Apply security baselines
- Install monitoring agents
- Configure corporate tools

Example:

New employee joins company →  
VM assigned →  
First login →  
All required tools installed automatically.

This improves:

- Productivity
- Standardization
- Compliance
- Operational efficiency

---

# 7. Deployment Process

## Step 1 – ARM Template Deployment

ARM provisions:

- OS Disk
- VM Size
- Admin Credentials
- Networking
- Security Rules

---

## Step 2 – Custom Script Extension Execution

CSE:

- Downloads PowerShell script
- Executes script silently
- Registers Task Scheduler entry

---

## Step 3 – Logon Task Created

Task Configuration:

| Setting | Value |
|----------|--------|
| Trigger | At Logon |
| Action | Execute PowerShell Script |
| Run Level | Highest Privilege |
| Context | User Logon |

---

## Step 4 – User Logs In

When RDP login occurs:

```

User Login
↓
Task Scheduler Trigger
↓
Script Executes
↓
Software Installed / Configuration Applied

```

Automation completes at user level.

---

# 8. Validation Steps

After deployment:

1. RDP into the VM
2. Open Task Scheduler:
```

taskschd.msc

```
3. Confirm task exists
4. Log off
5. Log back in
6. Verify installed applications or changes

---

# 9. Troubleshooting Observations

Common issues:

| Issue | Cause | Resolution |
|-------|--------|------------|
| Script not running | Execution Policy | Use `-ExecutionPolicy Bypass` |
| Task not created | Extension failure | Check CSE logs |
| Permission denied | Not elevated | Use highest privilege |
| Script path invalid | Download issue | Validate script URI |

CSE Logs Location:

```

C:\WindowsAzure\Logs\Plugins\

```

These logs help diagnose extension failures.

---

# 10. Architectural Insight

This deployment pattern reflects real-world enterprise VM automation design.

Key design principles applied:

- Infrastructure as Code
- Post-provision configuration automation
- Separation of infrastructure and user-level setup
- Scalable deployment pattern
- Governance-aligned VM provisioning

This pattern is widely used in:

- Virtual Desktop Infrastructure (VDI)
- Enterprise workstation provisioning
- Dev/Test environment setup
- Training lab environments

---

# 11. Key Concepts Learned

- ARM Template VM deployment
- Custom Script Extension workflow
- Windows Task Scheduler automation
- Logon-trigger execution model
- SYSTEM vs User execution context
- Enterprise VM provisioning strategy
- Automated environment configuration

---

# 12. Final Outcome

By the end of Day 4:

- I deployed a Windows VM using ARM Template.
- I configured Custom Script Extension successfully.
- I created a logon-trigger automation workflow.
- I validated automatic script execution.
- I understood enterprise-level VM automation strategy.

---

# 13. Conclusion

Day 4 focused on combining Infrastructure as Code with operating system-level automation.

This lab demonstrated how cloud infrastructure can be extended into automated environment configuration using Azure Custom Script Extension and Windows Task Scheduler.

The knowledge gained aligns with enterprise deployment standards and strengthens production-ready cloud engineering skills.
```

---
