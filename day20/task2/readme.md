

The Complete Architecture Picture


                INTERNET
                    │
                    ▼
┌─────────────────────────────────────┐
│  Public IP: Web-LB-PublicIP         │
│  Load Balancer: Web-Tier-LB         │ ← Users hit this
│  (Standard, Port 80)                │
└──────────────┬──────────────────────┘
               │  distributes traffic
       ┌───────┴───────┐
       ▼               ▼
┌─────────────┐ ┌─────────────┐
│ Web-TierVM-0│ │Web-Tier-VM-1│  ← Ubuntu + Apache + PHP
│ Web-NIC-0   │ │ Web-NIC-1   │  ← Each has own Public IP
│ 10.0.1.x    │ │ 10.0.1.x    │     (for SSH access)
└──────┬──────┘ └─────┬───────┘
       └───────┬───────┘
               │  calls http://10.0.2.100
               ▼
┌─────────────────────────────────────┐
│  Internal LB: App-Tier-Internal-LB  │
│  Fixed IP: 10.0.2.100               │ ← Private, no internet access
└──────────────┬──────────────────────┘
               │  distributes traffic
       ┌───────┴───────┐
       ▼               ▼
┌─────────────┐ ┌─────────────┐
│ AppTier-VM-0│ │App-Tier-VM-1│  ← Ubuntu + Python Flask
│ App-NIC-0   │ │ App-NIC-1   │  ← No public IP
│ 10.0.2.x    │ │ 10.0.2.x    │  ← Uses NAT Gateway for outbound
└──────┬──────┘ └─────┬───────┘
       └───────┬──────┘
               │  SQL connection (port 1433)
               ▼
┌─────────────────────────────────────┐
│  Azure SQL Server                   │
│  sqlserver-xxxxx.database.windows   │ ← PaaS, managed by Microsoft
│  Database: ThreeTierDB              │
└─────────────────────────────────────┘

NAT Gateway (ThreeTier-NAT-GW) ← Shared by App + DB subnets for outbound internet