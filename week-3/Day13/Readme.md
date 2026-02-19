## Here’s explanation of Azure Policy definition.

## Top-Level Structure

```json
{
  "properties": {
```

- Defines the main configuration block of the Azure Policy.
- All policy settings are contained inside `"properties"`.

---

```json
"displayName": "Allow Only East US and Standard_D2s_v3 VM Size",
```

- Friendly name shown in the Azure Portal.
- Helps administrators identify the purpose of the policy.

---

```json
"policyType": "Custom",
```

- Indicates this is a user-created policy.
- Other possible value: `"BuiltIn"` (created by Microsoft).

---

```json
"mode": "All",
```

- Specifies what resource types the policy evaluates.
- `"All"` means it applies to all resource types, including resource groups and subscription-level resources.
- Alternative is `"Indexed"` (used mainly for resources supporting tags and location).

---

```json
"description": "This policy allows resources only in East US region and only Standard_D2s_v3 VM size.",
```

- Explains what the policy does.
- Useful for documentation and governance clarity.

---

```json
"metadata": {
  "category": "Compute"
},
```

- Additional classification information.
- `"category": "Compute"` groups this policy under Compute in Azure Portal.

---

## Policy Rule Logic

```json
"policyRule": {
```

- Contains the actual enforcement logic.
- Defines conditions (`if`) and action (`then`).

---

### IF Condition

```json
"if": {
```

- Specifies when the policy should trigger.

---

```json
"anyOf": [
```

- Logical OR condition.
- If **any one** of the listed conditions is true → policy is triggered.

---

### Condition 1 – Restrict Location

```json
{
  "field": "location",
  "notEquals": "eastus"
}
```

- Checks the resource deployment location.
- If the resource is NOT in `"eastus"`, this condition becomes true.
- Because it's inside `anyOf`, it will immediately trigger a deny.

Effect:

- Only resources deployed in **East US** are allowed.
- Any other region is denied.

---

### Condition 2 – Restrict VM Size

```json
{
  "allOf": [
```

- Logical AND condition.
- All nested conditions must be true to trigger.

---

#### Sub-condition A

```json
{
  "field": "type",
  "equals": "Microsoft.Compute/virtualMachines"
}
```

- Applies only to Virtual Machine resources.
- Ensures this rule does not affect other resource types.

---

#### Sub-condition B

```json
{
  "field": "Microsoft.Compute/virtualMachines/sku.name",
  "notEquals": "Standard_D2s_v3"
}
```

- Checks the VM size (SKU).
- If VM size is NOT `Standard_D2s_v3`, condition becomes true.

---

### What This Means Together

The `allOf` block means:

- If the resource is a Virtual Machine
  AND
- Its size is NOT `Standard_D2s_v3`

→ then the condition becomes true.

---

## THEN Action

```json
"then": {
  "effect": "deny"
}
```

- If the `if` condition evaluates to true → Azure blocks the deployment.
- `"deny"` prevents the resource from being created or updated.

---

# Final Logical Summary

The policy denies deployment when:

1. The resource is NOT in East US
   OR
2. The resource is a Virtual Machine AND its size is NOT Standard_D2s_v3

---

# What Is Allowed?

Allowed scenarios:

- Any resource type in **East US**
- Virtual Machines in East US with size **Standard_D2s_v3**

---

# Important Behavior Note

Because `anyOf` is used at the top:

- A VM in West US → denied immediately (location rule)
- A VM in East US but size Standard_B2s → denied (size rule)

---
