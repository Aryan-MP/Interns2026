Task 1:
       TO create a Virtual-machine-scale-set(VMSS) by using images and make sure that it is scalable based on the condition.
       --its should be done in automation usering powershell script that is stored in storage account
    
    practical: 
    ---test whether it is scalable by using dummy script that automatically increases cpu usage and it can increase the instances.

steps:

   Select Subscription
   Create Resource Group
   Give VMSS name and region
   Create Azure Compute Gallery
   Create Image Definition
   Create an Image Version
    Create VM Scale Set using that image
    Configure Auto-scaling rule

Example:
    CPU > 70% → Add more VM instances
    CPU < 30% → Remove VM instances
    Use PowerShell script from Storage Account that increase cpu usage or login to vmss and run stress command to increase cpu usage

Task2:
     you are going to create a windows vm and configure the customs data and if custom data is not present install it in windows vm.

     pratical:
    ----test whether your iis web server hostpage is working on your public ip.

steps:
   
   Create Windows VM
    Pass Custom Data (PowerShell script)
    Script logic:(it is stored in storage account, advanced ---> extensions---> add custon script extension and script)
    Check IIS
    If not installed → install IIS
    Create a simple webpage
    Open browser
    Enter Public IP
    IIS default page or custom page is displayed
    or if you have given any message it is replaced

learning:

images: wrapping up of dependenices and configurations into one file.
types:
1) generalised images: In images it does not contain any user info like username,password and computer name or host name
2) specalised images: In images it contains user info like username, password and computer or host name

important:

linux apache default folder location : /var/www/html/index.html
logs are stored in : C drive/azuredata/logs
iis webserver default html location: c drive/inetpub/root/www/index.html