Task: Subnet Design for Virtual Network Based on Host Requirements

Description

In this task, a Virtual Network (VNet) was divided into three subnets to support specific numbers of hosts while ensuring:

No IP address overlap

Efficient utilization of address space

Compliance with standard subnetting practices used in Microsoft Azure networking

The required host capacities were:

Subnet 1 → 50 hosts

Subnet 2 → 30 hosts

Subnet 3 → 20 hosts

🎯 Goal

Design subnets that:

Provide sufficient usable IP addresses

Follow Azure reservation rules

Avoid address conflicts

Optimize IP allocation

Azure Subnetting Rule

In Azure, each subnet reserves 5 IP addresses for internal use:

Network address

Default gateway

DNS mapping

Future use (2 addresses)

Therefore, subnet sizing must consider usable addresses after reservation.

Subnet Size Calculation

Subnet sizes were chosen starting from the largest host requirement to prevent fragmentation and ensure efficient allocation.

🔹 Subnet 1 — 50 Hosts

Required usable IPs: ≥ 50

Chosen prefix: /26

Total IP addresses: 64

Usable IP addresses in Azure: 64 − 5 = 59 usable

✅ Satisfies requirement

🔹 Subnet 2 — 30 Hosts

Required usable IPs: ≥ 30

/27 provides only 27 usable → insufficient

Chosen prefix: /26

Total IP addresses: 64

Usable IP addresses: 59 usable

✅ Meets requirement with safe margin

🔹 Subnet 3 — 20 Hosts

Required usable IPs: ≥ 20

Chosen prefix: /27

Total IP addresses: 32

Usable IP addresses: 32 − 5 = 27 usable

✅ Sufficient for requirement

Subnet Address Allocation

To prevent overlap, ranges were assigned sequentially from the start of the VNet address space.

Subnet	Host Requirement	Prefix	Address Range
Subnet 1	50 hosts	/26	10.0.0.0/26
Subnet 2	30 hosts	/26	10.0.0.64/26
Subnet 3	20 hosts	/27	10.0.0.128/27
Why Sequential Allocation?

Sequential assignment ensures:

No address conflicts

Efficient utilization of IP space

Simpler network management

Scalability for future expansion

<img width="1920" height="1080" alt="Screenshot (152)" src="https://github.com/user-attachments/assets/bd36ed87-1364-4999-8512-a7ead3e67404" />


Outcome

Successfully designed three subnets with required capacities

Ensured no overlapping address ranges

Followed Azure-specific subnetting rules

Achieved efficient IP utilization
