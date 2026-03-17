#  Day-27 Lab

## Topic: EBS Volume Management, Docker Auto-Restart, Apache Configuration, System Monitoring, and S3 Static Website Hosting

---

#  Objective

In this lab we worked on several **system administration and AWS tasks** including:

* Attaching and formatting **additional EBS volumes**
* Making mounted storage **persistent**
* Running **Docker containers that restart automatically**
* Changing the **default Apache web root directory**
* Monitoring **CPU and memory usage via a web page**
* Hosting a **static website using Amazon S3**

These tasks demonstrate how infrastructure, containers, and storage can be managed inside AWS EC2.

---

#  Task-1: Create an Extra Volume, Format It, and Make It Persistent

---

# Step-1: Create an EBS Volume

Navigate to:

```text
AWS Console → EC2 → Elastic Block Store → Volumes
```

Click:

```
Create Volume
```

Configuration example:

| Setting           | Value                |
| ----------------- | -------------------- |
| Volume Type       | gp2 / gp3            |
| Size              | 10 GB                |
| Availability Zone | Same as EC2 instance |

---

# Step-2: Attach the Volume to EC2

Navigate to:

```
EC2 → Volumes → Actions → Attach Volume
```

Attach to the target EC2 instance.

Example device name:

```
/dev/xvdf
```

---

# Step-3: Verify Volume in EC2

Login to EC2 instance.

Run:

```bash
lsblk
```

Example output:

```
xvda
xvdf
```

---

# Step-4: Format the Volume

Create filesystem:

```bash
sudo mkfs -t ext4 /dev/xvdf
```

---

# Step-5: Create Mount Directory

Example directory:

```bash
sudo mkdir /mnt/driveD
```

---

# Step-6: Mount the Volume

```bash
sudo mount /dev/xvdf /mnt/driveD
```

Verify:

```bash
df -h
```

---

# Step-7: Make Mount Persistent

Edit the filesystem table:

```bash
sudo nano /etc/fstab
```

Add entry:

```
/dev/xvdf   /mnt/driveD   ext4   defaults,nofail   0   2
```

Test:

```bash
sudo mount -a
```

Now the volume will **automatically mount after reboot**.

---

#  Task-2: Run Docker Container After EC2 Reboot

---

# Step-1: Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
```

Start Docker:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

# Step-2: Run Container with Restart Policy

Run container using:

```bash
docker run -d -p 80:80 --restart unless-stopped nginx
```

Explanation:

| Option                   | Meaning                          |
| ------------------------ | -------------------------------- |
| -d                       | Run container in background      |
| -p                       | Map port                         |
| --restart unless-stopped | Container restarts automatically |

---

# Step-3: Verify Container

Check running containers:

```bash
docker ps
```

---

# Step-4: Reboot EC2

```bash
sudo reboot
```

After reconnecting run:

```bash
docker ps
```

You will see container running automatically.

---

#  Task-3: Change Apache Default Directory

Default Apache web directory:

```
/var/www/html
```

We changed it to:

```
/mnt/driveD/html
```

---

# Step-1: Install Apache

```bash
sudo yum install httpd -y
```

Start Apache:

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

---

# Step-2: Create New Web Directory

```bash
sudo mkdir -p /mnt/driveD/html
```

Add test page:

```bash
sudo nano /mnt/driveD/html/index.html
```

Example content:

```html
<h1>Custom Apache Directory</h1>
```

---

# Step-3: Modify Apache Configuration

Edit configuration file:

```
/etc/httpd/conf/httpd.conf
```

Find:

```
DocumentRoot "/var/www/html"
```

Change to:

```
DocumentRoot "/mnt/driveD/html"
```

Also update:

```
<Directory "/var/www">
```

to

```
<Directory "/mnt/driveD/html">
```

---

# Step-4: Restart Apache

```bash
sudo systemctl restart httpd
```

Now Apache serves files from:

```
/mnt/driveD/html
```

---

#  Task-4: Monitor CPU and Memory Using Web Application

Objective:

Display **CPU and memory utilization every 2 minutes in a web browser**.

---

# Step-1: Install Required Packages

```bash
sudo apt update
sudo apt install nginx sysstat -y
```

---

# Step-2: Create Monitoring Script

Create script:

```bash
nano monitor.sh
```

Example script:

```bash
#!/bin/bash

while true
do
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

echo "<h1>System Monitoring</h1>" > /var/www/html/index.html
echo "<p>CPU Usage: $CPU%</p>" >> /var/www/html/index.html
echo "<p>Memory Usage: $MEM%</p>" >> /var/www/html/index.html

sleep 120
done
```

Make executable:

```bash
chmod +x monitor.sh
```

---

# Step-3: Run Monitoring Script

```bash
./monitor.sh &
```

Open browser:

```
http://<EC2-IP>
```

You will see CPU and memory updates every **2 minutes**.

---

#  Task-5: Host Static Website Using S3

---

# Step-1: Create S3 Bucket

Navigate to:

```
AWS Console → S3 → Create Bucket
```

Example name:

```
day27-static-site
```

Disable:

```
Block Public Access
```

---

# Step-2: Upload Website Files

Upload files such as:

```
index.html
style.css
images
```

Example `index.html`:

```html
<h1>Welcome to My Static Website</h1>
```

---

# Step-3: Enable Static Website Hosting

Navigate to:

```
Bucket → Properties → Static Website Hosting
```

Enable and configure:

| Setting        | Value      |
| -------------- | ---------- |
| Index Document | index.html |
| Error Document | error.html |

---

# Step-4: Configure Bucket Policy

Add policy allowing public access.

```json
{
 "Version":"2012-10-17",
 "Statement":[{
   "Effect":"Allow",
   "Principal":"*",
   "Action":["s3:GetObject"],
   "Resource":["arn:aws:s3:::day27-static-site/*"]
 }]
}
```

---

# Step-5: Access Website

S3 provides endpoint like:

```
http://day27-static-site.s3-website-region.amazonaws.com
```

Open this URL to view the static website.

---
![alt text](<Screenshot (221).png>) ![alt text](<Screenshot (232).png>) ![alt text](<Screenshot (231).png>) ![alt text](<Screenshot (230).png>) ![alt text](<Screenshot (229).png>) ![alt text](<Screenshot (228).png>) ![alt text](<Screenshot (227).png>) ![alt text](<Screenshot (226).png>) ![alt text](<Screenshot (225).png>) ![alt text](<Screenshot (224).png>) ![alt text](<Screenshot (223).png>) ![alt text](<Screenshot (222).png>)