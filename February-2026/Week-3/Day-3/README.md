```markdown
# Week-2 / Day-13 / README.md

# Day 13 – Azure Policy: Creation, Definition, and Assignment

**Date:** February 18, 2026  
**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 13 was to understand and implement governance controls in Microsoft Azure using **Azure Policy**.

In this lab, we:

- Created three custom Azure Policy definitions using JSON.
- Assigned them at the Resource Group scope.
- Enforced governance rules during deployment.
- Tested compliance behavior using real resource creation attempts.

This session introduced policy-driven cloud governance and compliance enforcement mechanisms.

---

# 2. What is Azure Policy?

Azure Policy is a governance service that enables organizations to enforce standards and assess compliance across Azure resources.

Azure Policy is used to:

- Enforce organizational standards
- Control resource configurations
- Ensure compliance automatically
- Prevent misconfigured deployments
- Apply governance at scale

Azure Policy does not control *who* can create resources. Instead, it controls *how* resources must be configured.

---

# 3. Azure Policy Workflow

Azure Policy follows a structured lifecycle:

| Step | Description |
|------|------------|
| Define | Create policy rule using JSON |
| Assign | Attach policy to a scope (Resource Group / Subscription / Management Group) |
| Enforce | Azure evaluates rules during deployment |
| Comply | Resource allowed or denied based on rule |

Flow:

```

Define Policy → Assign Policy → Enforce Rule → Evaluate Compliance

````

Azure evaluates policies in real time during resource creation.

---

# 4. Scope Used in This Lab

All policies were assigned at:

**Resource Group Level**

This means:

- Every resource created inside that Resource Group must comply.
- Non-compliant deployments are automatically denied.

This approach is commonly used in enterprise environments to enforce governance boundaries within project-specific resource groups.

---

# 5. Custom Policy Implementations

---

# 5.1 Policy 1 – Restrict Resource Deployment to East US

## Purpose

Ensure that all resources are deployed only in the approved region: **East US**.

This prevents:

- Region sprawl
- Compliance violations
- Cost mismanagement
- Data residency issues

---

## Policy Definition

```json
{
    "properties": {
        "displayName": "Allow Resources Only in East US",
        "policyType": "Custom",
        "mode": "All",
        "description": "Allows resource creation only in eastus region.",
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
````

---

## Behavior

| Deployment Region | Result  |
| ----------------- | ------- |
| eastus            | Allowed |
| westus            | Denied  |
| centralindia      | Denied  |

When attempting to deploy outside East US, Azure returns a **Policy Deny Error** during deployment.

---

# 5.2 Policy 2 – Mandatory Tags Enforcement

## Purpose

Ensure every resource includes the following mandatory tags:

* Environment
* Owner

This supports:

* Cost tracking
* Resource ownership identification
* Lifecycle management
* Operational accountability

---

## Policy Definition

```json
{
    "properties": {
        "displayName": "Mandatory Environment and Owner Tags",
        "policyType": "Custom",
        "mode": "All",
        "description": "Ensures resources are created only if Environment and Owner tags are present.",
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

## Behavior

| Tags Provided       | Result  |
| ------------------- | ------- |
| Environment + Owner | Allowed |
| Missing Environment | Denied  |
| Missing Owner       | Denied  |
| No Tags             | Denied  |

Azure blocks deployment if either tag is missing.

---

# 5.3 Policy 3 – Restrict Storage Account Configuration

## Purpose

Ensure Storage Accounts:

* Use Standard SKU only
* Have Public Blob Access Disabled

This improves:

* Security posture
* Cost optimization
* Prevention of accidental data exposure

---

## Policy Definition

```json
{
    "properties": {
        "displayName": "Allow Only Standard SKU and Disable Public Access",
        "policyType": "Custom",
        "mode": "All",
        "description": "Allows storage account creation only if SKU is Standard and public access is disabled.",
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

## Behavior

| Configuration                  | Result  |
| ------------------------------ | ------- |
| Standard SKU + Public Disabled | Allowed |
| Premium SKU                    | Denied  |
| Public Access Enabled          | Denied  |

This policy prevents high-cost or insecure storage configurations.

---

# 6. Steps Performed in the Lab

---

## Step 1 – Created Custom Policies

Using Azure Portal:

1. Navigate to **Azure Portal**
2. Go to **Policy**
3. Select **Definitions**
4. Click **+ Create Policy Definition**
5. Paste JSON rule
6. Save policy

---

## Step 2 – Assign Policy to Resource Group

1. Go to **Policy → Assignments**
2. Click **Assign Policy**
3. Select:

   * Scope → Resource Group
   * Policy Definition → Custom Policy
   * Enforcement Mode → Enabled
4. Create assignment

---

## Step 3 – Test Policy Enforcement

We attempted to deploy resources violating the rules.

| Test Scenario                | Result  |
| ---------------------------- | ------- |
| Deploy VM in wrong region    | Blocked |
| Create resource without tags | Blocked |
| Create Premium Storage       | Blocked |

Azure returned a **Policy Deny Error** during deployment.

---

# 7. How Azure Evaluates Policies

Azure evaluates policies in real time during:

* ARM Template Deployment
* Bicep Deployment
* Azure Portal resource creation
* Azure CLI deployments
* Terraform deployments

The evaluation occurs before resource provisioning is completed.

If the policy condition matches and effect is "deny", the deployment is stopped immediately.

---

# 8. Azure Policy vs RBAC

| Feature        | RBAC              | Azure Policy             |
| -------------- | ----------------- | ------------------------ |
| Controls Who   | Yes               | No                       |
| Controls How   | No                | Yes                      |
| Security Focus | Access Control    | Configuration Compliance |
| Example        | Who can create VM | VM must use approved SKU |

RBAC and Azure Policy work together:

* RBAC controls permissions.
* Azure Policy controls configuration.

Together they provide complete governance and security enforcement.

---

# 9. Architectural Insight

Azure Policy is essential for enterprise cloud governance.

Without policies:

* Resources can be deployed in incorrect regions.
* Insecure configurations may be introduced.
* Cost control becomes difficult.
* Compliance requirements may be violated.

By enforcing governance at Resource Group or Subscription level:

* Security posture improves.
* Compliance audits become easier.
* Standardization is maintained.
* Infrastructure drift is minimized.

Azure Policy enables centralized governance across distributed teams.

---

# 10. Key Concepts Learned

* Azure Policy lifecycle
* Custom policy JSON structure
* Policy definition vs assignment
* Scope hierarchy (RG / Subscription / Management Group)
* Deny effect enforcement
* Real-time compliance evaluation
* Governance at scale
* Difference between RBAC and Policy
* Storage configuration enforcement
* Tag governance strategy

---

# 11. Final Outcome

By the end of Day 13:

* I successfully created three custom Azure Policies.
* I assigned them at Resource Group scope.
* I enforced region restriction rules.
* I implemented mandatory tag enforcement.
* I secured storage configuration standards.
* I validated real-time compliance blocking behavior.

This lab strengthened my understanding of governance, compliance, and enterprise cloud control mechanisms.

---

# 12. Conclusion

Day 13 focused on implementing governance controls using Azure Policy.

The session demonstrated how cloud environments can be centrally controlled and standardized through policy-based enforcement.

Azure Policy is a critical tool in production environments to ensure:

* Security compliance
* Cost optimization
* Configuration consistency
* Organizational governance

This lab enhanced my practical knowledge of compliance-driven cloud architecture design.

```
```
