Task: Azure Policy
    Azure Policy is a governance service in Azure that allows organizations to create, assign, and enforce rules to ensure resources comply with corporate standards and regulatory requirements.Azure Policy works by defining governance rules through a Policy Definition, which specifies what configurations are allowed or restricted for Azure resources. This definition is applied using a Policy Assignment, which attaches the rule to a specific Scope such as a Management Group, Subscription or Resource Group.

    You need to run this command to execute file 
        az deployment group create --resource-group suyogspektra-rg --template-file azure_policy.json
        az deployment group create --resource-group suyogspektra-rg --template-file azure_policy_all.json