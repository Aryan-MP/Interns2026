# Day-13

## Topic: Azure Policy – Creation, Definition, and Assignment

---

# Objective

In this lab, we worked with **Azure Policy** to enforce governance and compliance rules on resources.

We created **three custom Azure Policies**, defined them using JSON, and assigned them to a **Resource Group scope** to control how resources are deployed.

---

# What is Azure Policy?

Azure Policy is a service used to:

* Enforce organizational standards
* Control resource configurations
* Ensure compliance automatically
* Prevent misconfigured deployments
* Apply governance at scale

Unlike RBAC (who can create resources), Azure Policy controls **how resources must be created**.

---

#  Azure Policy Workflow

```
Define Policy → Assign Policy → Enforce Rule → Evaluate Compliance
```

| Step    | Description                         |
| ------- | ----------------------------------- |
| Define  | Create policy rule (JSON)           |
| Assign  | Attach to Scope (RG / Subscription) |
| Enforce | Azure evaluates during deployment   |
| Comply  | Resource allowed or denied          |

---

#  Scope Used in This Lab

We assigned policies at:

```
Resource Group Level
```

So all resources created inside this Resource Group must follow the defined rules.

---

# ✅ Policy-1: Allow Resources Only in "East US"

## 📌 Purpose

Ensure that all resources are deployed **only in the approved region (East US)**.

This prevents:

* Cost mismanagement
* Region sprawl
* Compliance violations

---

##  Policy Definition

```json
{
    "properties": {
        "displayName": "My Custom Policy",
        "policyType": "Custom",
        "mode": "All",
        "description": "This is a custom policy allows to create resources in eastus region.",
        "policyRule": {
            "if": {
                "not": {
                    "field": "location",
                    "in": ["eastus"]
                }
            },
            "then": {
                "effect": "deny"
            }
        }
    }
}
```

---

##  Behavior

| Deployment Region | Result    |
| ----------------- | --------- |
| eastus            |  Allowed |
| westus            |  Denied  |
| centralindia      |  Denied  |

---

# ✅ Policy-2: Mandatory Tags Enforcement

## 📌 Purpose

Ensure every resource includes:

* `Environment` tag
* `Owner` tag

This helps with:

* Cost tracking
* Resource ownership
* Lifecycle management

---

## 📄 Policy Definition

```json
{
    "properties": {
        "displayName": "Allows only if added environment and owner tags",
        "policyType": "Custom",
        "mode": "All",
        "description": "This policy allows to create resources only if environment and owner tags are added.",
        "policyRule": {
            "if": {
                "anyOf": [
                    {
                        "field": "tags[Environment]",
                        "exists": "false"
                    },
                    {
                        "field": "tags[Owner]",
                        "exists": "false"
                    }
                ]
            },
            "then": {
                "effect": "deny"
            }
        }
    }
}
```

---

## ✔ Behavior

| Tags Provided       | Result    |
| ------------------- | --------- |
| Environment + Owner |  Allowed |
| Missing Environment |  Denied  |
| Missing Owner       |  Denied  |
| No Tags             |  Denied  |

---

# ✅ Policy-3: Restrict Storage Account Configuration

## 📌 Purpose

Ensure Storage Accounts:

* Use **Standard SKU only**
* Have **Public Blob Access Disabled**

This improves:

* Security posture
* Cost optimization
* Prevents accidental exposure

---

## 📄 Policy Definition

```json
{
    "properties": {
        "displayName": "Allow only Standard SKU and Disable Public Access",
        "policyType": "Custom",
        "mode": "All",
        "description": "This policy allows to create storage accounts only if the SKU is standard and public access is disabled.",
        "policyRule": {
            "if": {
                "allOf": [
                    {
                        "field": "type",
                        "equals": "Microsoft.Storage/storageAccounts"
                    },
                    {
                        "anyOf": [
                            {
                                "field": "Microsoft.Storage/storageAccounts/sku.name",
                                "like": "Premium*"
                            },
                            {
                                "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
                                "equals": "true"
                            }
                        ]
                    }
                ]
            },
            "then": {
                "effect": "deny"
            }
        }
    }
}
```

---

## ✔ Behavior

| Configuration                  | Result    |
| ------------------------------ | --------- |
| Standard SKU + Public Disabled |  Allowed |
| Premium SKU                    |  Denied  |
| Public Access Enabled          |  Denied  |

---

#  Steps Performed in the Lab

## Step-1: Created Custom Policies

Using Azure Portal / CLI:

```
Azure Portal → Policy → Definitions → + Create Policy Definition
```

Added JSON rule and saved.

---

## Step-2: Assigned Policy to Resource Group

```
Policy → Assignments → Assign Policy
```

Selected:

* Scope → Resource Group
* Policy Definition → Created Custom Policy
* Enforcement Mode → Enabled

---

## Step-3: Tested Policy Enforcement

Attempted to deploy resources violating rules:

| Test                         | Result  |
| ---------------------------- | ------- |
| Deploy VM in wrong region    | Blocked |
| Create resource without tags | Blocked |
| Create Premium Storage       | Blocked |

Azure returned **Policy Deny Error** during deployment.

---

# 🔍 How Azure Evaluates Policies

Azure checks policies during:

* ARM Template Deployment
* Bicep Deployment
* Portal Creation
* CLI Creation
* Terraform Deployment

Policy enforcement is **real-time**.

---

#  Azure Policy vs RBAC

| Feature      | RBAC              | Azure Policy             |
| ------------ | ----------------- | ------------------------ |
| Controls Who | ✅                 | ❌                        |
| Controls How | ❌                 | ✅                        |
| Security     | Access            | Configuration            |
| Example      | Who can create VM | VM must use specific SKU |

They work together for complete governance.

---