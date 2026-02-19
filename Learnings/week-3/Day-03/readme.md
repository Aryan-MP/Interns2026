# 🚦 Azure Policy with Assignment using ARM Template

---

# 📌 What is Azure Policy?

Azure Policy is a governance service that enforces organizational standards and ensures compliance across your Azure environment.

It helps to:
- Enforce tagging
- Restrict resource locations
- Improve security
- Maintain governance

---

# 🎯 Project Objective

This project creates:

✔ Custom Policy Definition  
✔ Policy Assignment at Subscription Level  

Policy Rule:
Deny creation of resources if required tag is missing.



# 🧠 Policy Logic

If:
```
Required tag does NOT exist
```

Then:
```
Deny resource creation
```

---

# 🛠️ ARM Template Components

## 1️⃣ Policy Definition

Resource Type:
```
Microsoft.Authorization/policyDefinitions
```

Defines:
- displayName
- description
- policyRule
- effect

---

## 2️⃣ Policy Assignment

Resource Type:
```
Microsoft.Authorization/policyAssignments
```

Assigns policy at subscription level.

---

# 🔧 Parameters Used

| Parameter | Purpose |
|-----------|----------|
| policyName | Name of custom policy |
| policyAssignmentName | Name of assignment |
| tagName | Required tag name |

Default Tag:
```
Environment
```

---

# 🚀 Deployment Steps

## 1️⃣ Login to Azure

```
az login
```

## 2️⃣ Deploy Template

```
az deployment sub create \
  --location eastus \
  --template-file azure-policy-with-assignment.json
```

---

# 📊 What Happens After Deployment?

If you try to create a resource without:

```
Environment = Dev
```

Azure will:

❌ Deny the deployment

---

# 🔐 Policy Effects

| Effect | Meaning |
|--------|---------|
| deny | Blocks resource creation |
| audit | Logs non-compliance |
| append | Adds property automatically |
| deployIfNotExists | Auto-remediation |

---

# 🌍 Real-World Use Cases

- Enforce tagging standards
- Block public IP creation
- Restrict VM sizes
- Restrict resource locations
- Enforce encryption policies

