# Azure Policy

**Azure Policy is a service in Microsoft Azure that helps you control, manage, and enforce rules on your cloud resources.**

---

## What Does Azure Policy Do?

Azure Policy:

* **Checks if your resources follow company rules**
* **Blocks resources that break rules**
* **Shows compliance status in a dashboard**
* **Fixes non-compliant resources automatically**

---

## Simple Real-Life Example

Imagine your company says:

* Only deploy VMs in East US
* All resources must have a Department tag
* Only specific VM sizes are allowed

**Azure Policy can:**

* Deny deployment if wrong region
* Automatically add missing tags
* Block unapproved VM sizes

---

## Policy Definition

**A policy definition is the actual rule written in JSON.**

It answers:

* What condition to check?
* What action to take?

Every policy definition has:

* metadata
* policyRule
* effect

---

## Policy Effects

| Effect                | What It Does                            |
| --------------------- | --------------------------------------- |
| **Deny**              | Blocks the resource                     |
| **Audit**             | Just logs it                            |
| **Modify**            | Changes the resource                    |
| **DeployIfNotExists** | Creates required resource automatically |
| **DenyAction**        | Blocks specific actions                 |

---

## Example — Policy Definition

```json
{
  "properties": {
    "displayName": "Allow only East US",
    "policyType": "Custom",
    "mode": "All",
    "description": "Resources must be deployed in East US",
    "parameters": {},
    "policyRule": {
      "if": {
        "field": "location",
        "notEquals": "eastus"
      },
      "then": {
        "effect": "deny"
      }
    }
  }
}
```

### What happens?

* Azure checks resource location
* If NOT **eastus** → deployment blocked

---

## Initiative

An **initiative** is a collection of multiple policies.

### Why use it?

* Easier management
* Assign once → many policies applied
* Used in enterprise environments

**Think:** Initiative = Policy bundle 

---

## Example — Governance Initiative

```json
{
  "properties": {
    "displayName": "Basic Governance Initiative",
    "description": "Group of governance policies",
    "policyType": "Custom",
    "parameters": {},
    "policyDefinitions": [
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/allowed-locations"
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/require-tag"
      }
    ]
  }
}
```

### What happens?

* Both policies run together
* Single assignment controls many rules

---

## Assignment (Apply the Policy)

A policy does **nothing** until you assign it.

You can assign at:

* Management group
* Subscription
* Resource group
* Resource

---

## Example — Assign to Subscription

```json
{
  "properties": {
    "displayName": "Enforce East US Location",
    "policyDefinitionId": "/subscriptions/<subscription-id>/providers/Microsoft.Authorization/policyDefinitions/allow-eastus",
    "scope": "/subscriptions/<subscription-id>",
    "enforcementMode": "Default"
  }
}
```

### What happens?

* Policy becomes active
* All resources in subscription are checked

---

## Effect = What Azure Does When Rule Is Violated

Location in policy:

```
policyRule → then → effect
```

---

### Deny Effect (Most Strict)

```json
"then": {
  "effect": "deny"
}
```

* Blocks resource creation.

---

### Audit Effect (Safe Mode)

```json
"then": {
  "effect": "audit"
}
```

* Only logs violation (good for testing)

---

### Modify Effect (Auto-fix)

```json
"then": {
  "effect": "modify",
  "details": {
    "operations": [
      {
        "operation": "addOrReplace",
        "field": "tags.environment",
        "value": "production"
      }
    ]
  }
}
```

* Azure automatically adds tag.

---

### DeployIfNotExists Effect

Used when required resource is missing → Azure deploys it.

Common uses:

* diagnostic settings
* monitoring
* security agents

```json
"then": {
  "effect": "deployIfNotExists",
  "details": {
    "type": "Microsoft.Insights/diagnosticSettings",
    "existenceCondition": {
      "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
      "equals": "true"
    }
  }
}
```

---

## Policy Parameters (Reusable Policies)

* Parameters make policy dynamic and reusable.
* Without parameters → need many policies
* With parameters → one policy works everywhere
* **Very important for real projects**

---

## Example — Parameterized Location Policy

```json
{
  "properties": {
    "displayName": "Allowed Locations Parameterized",
    "policyType": "Custom",
    "mode": "All",
    "parameters": {
      "allowedLocations": {
        "type": "Array",
        "metadata": {
          "description": "List of allowed locations"
        }
      }
    },
    "policyRule": {
      "if": {
        "field": "location",
        "notIn": "[parameters('allowedLocations')]"
      },
      "then": {
        "effect": "deny"
      }
    }
  }
}
```

### Values Passed During Assignment

```json
{
  "allowedLocations": {
    "value": ["eastus", "westus"]
  }
}
```

* Same policy works for different regions.

---

## Exclusion (notScopes)

Sometimes you want policy everywhere **except** some resources.

Use:

```
notScopes = exclusion list
```

### Example

```json
{
  "properties": {
    "displayName": "Location Policy with Exclusion",
    "policyDefinitionId": "/subscriptions/<sub-id>/providers/Microsoft.Authorization/policyDefinitions/allow-eastus",
    "scope": "/subscriptions/<sub-id>",
    "notScopes": [
      "/subscriptions/<sub-id>/resourceGroups/network-rg"
    ]
  }
}
```

### What happens?

* Policy applies to whole subscription
* **Except** network-rg

---

## Azure Policy vs RBAC (Quick Reminder)

| Feature  | Azure Policy           | Azure RBAC         |
| -------- | ---------------------- | ------------------ |
| Controls | Resource configuration | User permissions   |
| Purpose  | Compliance             | Access control     |
| Blocks   | Bad configurations     | Unauthorized users |
