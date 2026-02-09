# Task 01: Azure Virtual Machine Deployment & Image Creation
## Description

In this task, I successfully deployed an Azure Virtual Machine and created a reusable VM image. This image can be used to deploy additional Virtual Machines or Virtual Machine Scale Sets, enabling faster and consistent infrastructure provisioning.

### Step 1: Virtual Machine Deployment
- Created an Ubuntu-based Azure Virtual Machine
- Configured required settings such as:
1. Resource Group
2. Virtual Network and Subnet
3. VM Size
4. OS Disk and Networking
- Verified that the VM was successfully deployed and running

<img width="1920" height="1032" alt="image" src="https://github.com/user-attachments/assets/2f3ba9f2-4e66-47e3-8905-127f559ff96b" />

---

### Step 2: VM Image Creation
- Created a custom VM image using the Capture option
- The image captures:
1. OS type and configuration
2. Installed software and VM settings
- This image can be reused to:
1. Deploy multiple VMs
2. Create Virtual Machine Scale Sets
3. Maintain consistency across environments

<img width="1920" height="1032" alt="image" src="https://github.com/user-attachments/assets/d7890a62-d2a2-4551-88ee-03753924162a" />

<img width="1920" height="1080" alt="Screenshot (138)" src="https://github.com/user-attachments/assets/f3a5b323-e942-4cba-87fc-54a3927b055b" />

---

### Outcome
- Successfully deployed an Azure VM
- Created a reusable VM image (Virtual Image Scale set)
- Improved deployment efficiency and scalability using Azure images

---

# Task 02: Azure VM Deployment, Script Execution & Application Access
## Description
In this task, I created an Azure Virtual Machine, uploaded and executed a script file, deployed a simple “Hello World” application, and verified public access using the VM’s public IP address. I also connected to the VM using Remote Desktop Protocol (RDP) and installed required applications.

---

### Step 1: Virtual Machine Creation
- Created an Azure Virtual Machine with required configurations
- Configured networking to allow public access
- Verified successful VM deployment

<img width="1920" height="1080" alt="Azure VM Deployment" src="https://github.com/user-attachments/assets/40ee9971-cdef-476b-a589-890b03bcbbf8" />

---

### Step 2: Script File Upload
- Uploaded a script file to the VM (Blob Storage / VM file system)
- Used the script to automate application setup
- Ensured the script executed successfully

<img width="1920" height="1080" alt="Script Upload" src="https://github.com/user-attachments/assets/04d305ac-fd30-4c1e-8988-f311c283297f" />

---

### Step 3: Application Deployment
- Deployed a simple “Hello World” application on the VM
- ccessed the application using the VM’s public IP address

<img width="1920" height="1080" alt="Hello World Application" src="https://github.com/user-attachments/assets/0e78e726-4209-4b8a-9511-6a72437898af" />

---

### Step 4: Remote Desktop Connection
- Connected to the VM using Remote Desktop Protocol (RDP)
- Installed required browsers:
1. Google Chrome
2. Microsoft Edge
- Verified successful remote access and software installation

<img width="786" height="593" alt="Remote Desktop Connection" src="https://github.com/user-attachments/assets/5654c757-3581-4927-85b3-61e534f0917a" />

---

### Outcome
- Successfully created and configured an Azure Virtual Machine
- Uploaded and executed a deployment script
- Deployed and accessed a web application using public IP
- Verified VM access via Remote Desktop and installed applications/>
