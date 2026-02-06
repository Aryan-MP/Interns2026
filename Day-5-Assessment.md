## Day 5 – Assessment: The Infrastructure Challenge

### Objective

Manually build and connect all the individual components required to launch a functional Virtual Machine. You must ensure all resources are compatible and optimized for the lowest possible latency with cost efficiency.


### Scenario

You are tasked with deploying a standalone server. Instead of using the "Quick Create" workflow, you must prepare the environment step-by-step. If any component is in the wrong location or uses an incompatible configuration, the VM will fail to deploy or communicate.

### Exercise 1

**Task 1: Networking Setup**

* Create a **Virtual Network (VNet)**.
* Define a **Subnet** within that VNet.
* **Goal:** Ensure the address space is sufficient for future scaling.

**Task 2: Security & Entry Points**

* Create a **Network Security Group (NSG)**.
* Configure a rule that allows you to remotely manage the VM.
* Create a **Public IP Address** to allow external connectivity.

**Task 3: The Connection Layer**

* Create a **Network Interface (NIC)**.
* Manually associate the VNet, Subnet, NSG, and Public IP you created in the previous steps.

**Task 4: Storage Allocation**

* Create a **Managed Data Disk**.
* **Constraint:** This disk must be physically located to ensure zero-latency attachment to your compute resource.

**Task 5: Final Assembly (Compute)**

* Deploy a **Virtual Machine**.
* **Requirement:** Do not create new networking or storage during this step. You must **attach** the NIC and the Data Disk you prepared in Tasks 3 and 4.

**Task 6: Validation**

* Log in to the machine and verify that the extra data disk is visible and ready for use.
* **Deliverables:** 
    - A screenshot of the "Topology" view in the Azure portal showing the relationship between these resources.
    - Screenshot of each resource deployment from the deployments page
    - Document with the necessary information like VM, VNet SKU's, IP addresses etc

