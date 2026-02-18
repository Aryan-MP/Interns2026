Task 1:
    This Command to run the template.json File :
        az deployment group create --resource-group suyogspektra-rg --template-file template.json --parameters parameters.json


Task 2:
    RBAC (Role Based Access Control):
        Azure RBAC is an authorization system that controls who can do what on which resource. It is Built on Security Principle, Role Defination, Scope. What are different type of role built in role and custom role.
            Built In Role : Built in roles are predefined permission sets provided by Azure that define what actions a user or identity can perform on Azure resources. The most common role are Owner, Contributor, Reader.

            Custom Role : A custom role is a user-defined role in Azure RBAC that allows organizations to create tailored permission sets based on specific access requirements.  