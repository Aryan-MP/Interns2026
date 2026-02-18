TASK 1:
Given a virtual network 
And must divide it into three subnets that can support 50, 30, and 20 hosts
while ensuring no overlap and efficient IP usage according to standard subnetting practices used in Microsoft Azure networking.
STEPS PERFORMED :
To achieve this, subnet sizes must be chosen based on host requirements, starting with the largest.
A subnet that supports 50 hosts requires a /26 prefix, which provides 64 total IP addresses (59 usable after Azure reserves five). 
The next requirement, 30 hosts, also needs a /26 because a /27 would only provide 27 usable addresses, which is insufficient. 
The final subnet for 20 hosts can use a /27 prefix, which provides 32 total IPs (27 usable). 
Assigning ranges sequentially from the start of the VNet prevents overlap: 10.0.0.0/26 for Subnet1 (50 hosts), 10.0.0.64/26 for Subnet2 (30 hosts), and 10.0.0.128/27 for Subnet3 (20 hosts). 
This design ensures each subnet has enough usable addresses, avoids address conflicts, and uses IP space efficiently while following proper cloud subnet allocation practices.<img width="1916" height="938" alt="Screenshot 2026-02-18 104740" src="https://github.com/user-attachments/assets/453a7db8-bd1e-42e0-a415-ef4d63612279" />
<img width="1916" height="938" alt="Screenshot 2026-02-18 104740" src="https://github.com/user-attachments/assets/dc4df87d-e741-4366-b0bd-96e0884611c2" />
