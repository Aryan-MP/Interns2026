# Azure Portal Tasks – Summary

## Task 1 — Image Snapshot → VM Scale Set with Autoscaling

- Created both **generalized** and **specialized** VM images by capturing snapshots from configured source VMs (generalized after deprovisioning, specialized with state preserved).
- Built a **Virtual Machine Scale Set (VMSS)** using the captured image to ensure consistent instance configuration across nodes.
- Configured VMSS capacity settings with **2 default instances** and **4 maximum instances** to enable horizontal scaling boundaries.
- Integrated a **Load Balancer** to distribute incoming traffic across VMSS instances and defined inbound NAT/load-balancing rules for required ports.
- Enabled **autoscale rules** based on CPU metrics with a threshold of **>70% utilization**.
- Executed a PowerShell stress script inside the VM to generate sustained CPU load, triggering autoscale and automatic provisioning of an additional instance.
- Verified scale-out behavior through instance count metrics and backend pool membership updates.

## Task 2 — VM Provisioning with Custom Data & Extensions

- Provisioned a VM with a **custom data script** passed at creation time for automated bootstrap configuration.
- Script parameters enabled installation of **Google Chrome** and **IIS**, validating post-deployment software provisioning.
- Stored the powershell script in a **Storage Account container** for reuse and centralized version control.
- Applied the script again using **VM Extensions**, linking the stored file to the VM for remote execution and configuration drift recovery.
- Confirmed successful execution via extension status, installed components, and generated custom data output within the VM.
- Approach demonstrates two methods: **inline custom data at deploy time** and **post-deployment extension-based configuration**.

file under Scripts -> chrome_IISEXT.ps1
