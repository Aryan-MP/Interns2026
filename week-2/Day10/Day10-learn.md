## 🔷 Azure Architecture Overview

**Components**

- 1 Virtual Network (VNet)
- 2 Subnets
  - Public Subnet
  - Private Subnet

- 2 Virtual Machines
  - VM1 (Public VM)
  - VM2 (Private VM)

- 2 Network Interface Cards (NICs)
- 1 Public IP (attached to Public VM)

---

## 🔷 Logical Architecture Explanation

1. A **Virtual Network (VNet)** is the top-level network container.
2. Inside the VNet, create:
   - **Public Subnet**
   - **Private Subnet**

3. VM1 is deployed in the Public Subnet.
   - NIC1 attached to VM1.
   - Public IP (PIP) attached to NIC1.

4. VM2 is deployed in the Private Subnet.
   - NIC2 attached to VM2.
   - No Public IP (private access only).

5. Communication:
   - Internet → Public IP → NIC1 → VM1
   - VM1 → Private IP → VM2 (via VNet internal routing)

---

## 🔷 Architecture Diagram (Using Comma and Dot Format)

```
Internet
  .
  .
Public IP (PIP)
  .
  .
NIC1 , VM1 (Public VM)
  .
  .
Public Subnet
  .
  .
Virtual Network (VNet)
  .
  .
Private Subnet
  .
  .
NIC2 , VM2 (Private VM)
```

---

## 🔷 Expanded Architecture with Clear Relationships

```
Internet
  .
Public IP
  .
NIC1
  .
VM1 (Public)
  .
Public Subnet
  .
Virtual Network
  .
Private Subnet
  .
NIC2
  .
VM2 (Private)
```

---

## 🔷 Traffic Flow

- External users access **VM1** via Public IP.
- VM1 can securely communicate with VM2 using private IP.
- VM2 cannot be accessed directly from the Internet.
- Optional: NSG rules control inbound/outbound traffic on each subnet or NIC.


# another option

## 🔷 Azure Architecture with NSG Included

### 🔹 Updated Components

- 1 Virtual Network (VNet)

- 2 Subnets
  - Public Subnet
  - Private Subnet

- 2 Virtual Machines
  - VM1 (Public VM)
  - VM2 (Private VM)

- 2 Network Interface Cards (NICs)

- 1 Public IP (attached to Public VM)

- 2 Network Security Groups (NSGs)
  - NSG-Public
  - NSG-Private

---

## 🔷 Visual Architecture Layout

![Image](https://learn.microsoft.com/en-us/azure/virtual-network/media/subnet-extension/subnet-extension.png)

![Image](https://learn.microsoft.com/en-us/azure/virtual-network/media/network-security-group-how-it-works/network-security-group-interaction.png)

![Image](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/media/default-outbound-access/explicit-outbound-options.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/0%2AnjdtBBmzr-J_kQGY)

---

## 🔷 Logical Design Explanation (With NSG)

### 1️⃣ Virtual Network (VNet)

The VNet acts as the main network boundary. Both subnets exist inside this VNet.

---

### 2️⃣ Public Subnet

Contains:

- VM1
- NIC1
- Public IP
- NSG-Public (attached to subnet or NIC)

**NSG-Public Rules Example**

- Allow RDP (3389) or SSH (22) from trusted IPs only
- Allow HTTP/HTTPS (80/443) if required
- Deny all other inbound traffic

Traffic Flow:

```
Internet
  .
Public IP
  .
NSG-Public
  .
NIC1
  .
VM1
```

---

### 3️⃣ Private Subnet

Contains:

- VM2
- NIC2
- NSG-Private

No Public IP assigned.

**NSG-Private Rules Example**

- Allow traffic from Public Subnet (VM1 private IP)
- Allow required internal ports only
- Deny all inbound traffic from Internet

Traffic Flow:

```
VM1 (Private IP)
  .
NSG-Private
  .
NIC2
  .
VM2
```

---

## 🔷 Full Text-Based Diagram (With NSG)

```
Internet
  .
Public IP
  .
NSG-Public
  .
NIC1 , VM1 (Public VM)
  .
Public Subnet
  .
Virtual Network (VNet)
  .
Private Subnet
  .
NSG-Private
  .
NIC2 , VM2 (Private VM)
```

---

## 🔷 Security Behavior

✔ VM1 is accessible from Internet (controlled by NSG-Public)
✔ VM2 is NOT accessible from Internet
✔ VM1 can communicate with VM2 internally
✔ NSGs filter traffic before it reaches the VM

