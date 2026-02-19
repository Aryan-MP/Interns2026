# 📡 Networking Concepts – Complete Guide

---

## 1️⃣ What is Networking?

Networking is the process of connecting two or more devices to share data and resources.

### Why Did Networking Come Into the Picture?

- To enable communication between computers
- To share resources (files, printers, internet)
- To allow secure communication between two mediums
- To support business, cloud, and internet infrastructure

👉 In simple words:
**Networking = Secure communication between two or more systems**

---

# 🌍 IP Address

An IP (Internet Protocol) address is a unique identifier assigned to every device on a network.

Example:
```
192.168.1.10
```

### Types of IP Address

## 🔹 Public IP Address
- Accessible over the internet
- Provided by ISP
- Globally unique

## 🔹 Private IP Address
- Used inside local networks
- Not accessible from internet
- Used in homes, offices, organizations

Private IP Ranges:
```
10.0.0.0     – 10.255.255.255
172.16.0.0   – 172.31.255.255
192.168.0.0  – 192.168.255.255
```

---

# 🏷️ Classful Addressing

IP addresses were divided into classes:

| Class | Range | Default Subnet Mask | Usage |
|-------|-------|--------------------|-------|
| A | 1.0.0.0 – 126.255.255.255 | 255.0.0.0 | Large networks |
| B | 128.0.0.0 – 191.255.255.255 | 255.255.0.0 | Medium networks |
| C | 192.0.0.0 – 223.255.255.255 | 255.255.255.0 | Small networks |
| D | 224.0.0.0 – 239.255.255.255 | Multicast | Multicast |
| E | 240.0.0.0 – 255.255.255.255 | Experimental | Research |

---

# 🏷️ Classless Addressing (CIDR)

CIDR = Classless Inter-Domain Routing

Instead of classes, we use prefix notation.

Example:
```
192.168.1.0/24
```

Here:
- /24 means 24 bits are network bits
- Remaining bits are host bits

---

# 📊 CIDR Range

CIDR formula:
```
2^(32 - prefix)
```

Example:
```
/24 → 2^(32 - 24) = 2^8 = 256 IP addresses
```

---

# 🔌 Networking Devices

## 🔹 Hub
- Broadcasts data to all devices
- No intelligence

## 🔹 Switch
- Sends data to specific device using MAC address
- More efficient than hub

## 🔹 Router
- Connects different networks
- Routes data using IP addresses

---

# 🌐 Subnet Basics

In every subnet:

- First IP → Network Address (Reserved)
- Last IP → Broadcast Address (Reserved)
- Usable IPs = Total - 2

Example:
```
10.0.0.0/24
Network IP     → 10.0.0.0
Broadcast IP   → 10.0.0.255
Usable Range   → 10.0.0.1 – 10.0.0.254
```

In many cloud environments:
- First usable IP is Gateway Address

---

# 🧮 Calculating Number of Networks

Formula:
```
2^X
```

Where:
X = Number of bits borrowed

Example:
Borrow 3 bits
```
2^3 = 8 networks
```

---

# 🧮 Calculating Number of Hosts

Formula:
```
2^(Host Bits) - 2
```

Host Bits:
```
32 - Network Bits
```

Example:
```
/24 → 32 - 24 = 8 host bits
2^8 - 2 = 254 usable hosts
```

---

# 🎭 Subnet Mask

Subnet mask identifies network and host portion.

Examples:

| CIDR | Subnet Mask |
|------|------------|
| /8 | 255.0.0.0 |
| /16 | 255.255.0.0 |
| /24 | 255.255.255.0 |
| /25 | 255.255.255.128 |

---

# 🔢 Binary to Decimal Conversion

Binary to Decimal Example:
```
11000000 = 128 + 64 = 192
```

Decimal to Binary Example:
```
192 → 11000000
```

Each octet:
```
128 64 32 16 8 4 2 1
```

---

# 📦 IP Address Structure

1 Byte = 8 bits  
IPV4 Address = 4 octets  

Example:
```
8.8.8.8
```

Total:
```
4 × 8 bits = 32 bits
```

---

# 🌎 IPV4 vs IPV6

## 🔹 IPV4
- 32-bit address
- Example: 192.168.1.1
- Limited addresses (~4.3 billion)

## 🔹 IPV6
- 128-bit address
- Example:
```
2001:0db8:85a3:0000:0000:8a2e:0370:7334
```
- Very large address space
- Solves IPV4 exhaustion problem

---

# ✅ Summary

- Networking enables secure communication
- IP address uniquely identifies devices
- Classful and Classless addressing divide networks
- CIDR provides flexible subnetting
- Subnet masks separate network & host bits
- IPV4 = 32 bits
- IPV6 = 128 bits

---

📘 End of Networking Concepts
