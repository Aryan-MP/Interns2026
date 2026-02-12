# Day 6 - Assignment

## Task - 2 Automated IIS & Software Installation using Custom Script Extension

### Custom Data Provided
InstallIIS = True
InstallChrome = True
IISData = "Hello"
### Logic Constraint
If installIIS = true → Install IIS
If installChrome = true → Install Chrome
If any value is false → Skip installation of that component

### 1. Windows Virtual Machine Deployment
Deployed a Windows VM
Configured networking and remote access
Enabled support for extensions

### 2. Custom Data Configuration
Passed custom parameters during VM creation
Used custom data to control installation logic
Ensured parameters were accessible inside the VM

### 3. Custom Script Extension Implementation
Attached Custom Script Extension to the VM
Executed PowerShell script that:
Parsed custom data
Evaluated conditional flags
Installed IIS when enabled
Installed Chrome when enabled
Configured IIS default page with provided data ("hello")

### 4. Validation
Verified IIS role installation
Confirmed Chrome installation
Accessed IIS via browser using Public IP
Validated web output displaying configured data
