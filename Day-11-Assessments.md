## Topic: Azure RBAC (Role-Based Access Control)

#  Azure RBAC (Role-Based Access Control)

Azure RBAC is a system that manages **who can access what and what actions they can perform** on Azure resources.

It follows the principle of:

> **Least Privilege Access**
> Users get only the permissions required to do their job.

---

##  RBAC Components

Azure RBAC is built using three main elements:

```
Security Principal + Role Definition + Scope = Access
```

---

###  Security Principal

An identity requesting access.

| Type              | Example             |
| ----------------- | ------------------- |
| User              | Individual engineer |
| Group             | DevOps Team         |
| Service Principal | Application         |
| Managed Identity  | Azure Resource      |

---

###  Role Definition

Defines **what actions are allowed**.

It is a collection of permissions like:

```
Read
Write
Delete
List Keys
Start VM
Stop VM
```

---

###  Scope

Defines **where the access applies**.

RBAC can be assigned at different levels:

```
Management Group → Subscription → Resource Group → Resource
```

Permissions inherit downward.

---

##  RBAC Scope Hierarchy

| Level            | Example                 |
| ---------------- | ----------------------- |
| Management Group | Entire Organization     |
| Subscription     | Billing boundary        |
| Resource Group   | Project-level control   |
| Resource         | Individual VM / Storage |

---

#  Built-in Azure Roles

Azure provides many predefined roles.

---

##  Commonly Used Roles

| Role                      | Description                         |
| ------------------------- | ----------------------------------- |
| Owner                     | Full access + can assign roles      |
| Contributor               | Full access but cannot grant access |
| Reader                    | View-only access                    |
| User Access Administrator | Manage RBAC assignments             |

---

##  Compute Roles

| Role                        | Use Case                            |
| --------------------------- | ----------------------------------- |
| Virtual Machine Contributor | Manage VMs only                     |
| DevTest Labs User           | Use labs but cannot modify policies |

---

##  Storage Roles

| Role                          | Use Case                |
| ----------------------------- | ----------------------- |
| Storage Account Contributor   | Manage storage accounts |
| Storage Blob Data Contributor | Access blob data        |

---

##  Network Roles

| Role                 | Use Case           |
| -------------------- | ------------------ |
| Network Contributor  | Manage VNets, NSGs |
| DNS Zone Contributor | Manage DNS         |

---

#  RBAC Assignment Example

Example Scenario:

> Give a developer permission to manage only VMs in one Resource Group.

Assignment:

* Security Principal → Developer User
* Role → Virtual Machine Contributor
* Scope → Resource Group

This ensures:
✔ Cannot modify networking
✔ Cannot delete storage
✔ Cannot change permissions

---

#  RBAC vs Traditional Access Control

| Traditional        | Azure RBAC         |
| ------------------ | ------------------ |
| Static Permissions | Dynamic Role-Based |
| Hard to Audit      | Fully Traceable    |
| Broad Access       | Least Privilege    |
| Manual Governance  | Policy Driven      |

---

#  How to View RBAC in Azure Portal

1. Go to Resource / Resource Group / Subscription
2. Click **Access Control (IAM)**
3. View:

   * Role Assignments
   * Role Definitions
   * Inherited Permissions

---

#  How to Assign a Role

Steps:

1. Open Resource Group
2. Select **Access Control (IAM)**
3. Click **Add → Add Role Assignment**
4. Select Role
5. Select User/Group
6. Save

---

#  Best Practices for RBAC

* Follow Least Privilege Principle
* Assign roles at smallest scope possible
* Avoid giving Owner role unnecessarily
* Use Groups instead of individual assignments
* Audit access regularly
* Use Managed Identities for automation

---

#  Real-World Importance of RBAC

RBAC ensures:

✔ Security boundaries
✔ Separation of duties
✔ Controlled deployments
✔ Compliance readiness
✔ Reduced risk of accidental deletion
✔ Enterprise-grade governance

---