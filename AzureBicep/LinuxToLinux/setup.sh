#!/bin/bash

set -e

echo "Installing KVM & dependencies..."
apt update -y
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cloud-image-utils

systemctl enable libvirtd
systemctl start libvirtd

echo "Creating shared directory..."
mkdir -p /shared-data     #Creates a folder named shared-data at the root (/) level. -p Creates parent directories if they do not exist
chmod 777 /shared-data

echo "Moving to image directory..."
cd /var/lib/libvirt/images

echo "Downloading Ubuntu cloud image..."
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O inner-base.img

echo "Creating inner VM disk..."
qemu-img create -f qcow2 -F qcow2 -b inner-base.img inner-vm.qcow2 15G   

echo "Creating cloud-init config..."

cat > user-data <<EOF
#cloud-config
password: azureuser
chpasswd: { expire: False }
ssh_pwauth: True
EOF

cloud-localds seed.img user-data

echo "Creating Inner VM..."
virt-install \
 --name inner-vm \
 --memory 2048 \
 --vcpus 2 \
 --disk path=/var/lib/libvirt/images/inner-vm.qcow2,format=qcow2 \   # qcow2 is a QEMU disk format (supports snapshots & compression)
 --disk path=/var/lib/libvirt/images/seed.img,device=cdrom \
 --network network=default \       #Connects VM to libvirt's default virtual network
 --filesystem /shared-data,shared-data,mode=mapped \    # Maps host's /shared-data to VM's /shared-data with read/write access
 --os-variant ubuntu22.04 \         #Optimizes VM settings for Ubuntu 22.04
 --import \
 --noautoconsole          

echo "Nested VM created successfully."



# qemu-kvm
# Installs QEMU with KVM support
# Provides hardware virtualization capability
# This is the core engine that runs virtual machines

# libvirt-daemon-system
# Installs the libvirt service (background daemon)
# Manages virtual machines (start, stop, networking, storage)
# Required to control VMs through libvirt

# libvirt-clients
# Installs command-line tools like virsh
# Used to create, list, and manage virtual machines
# Provides user control over the hypervisor

# bridge-utils
# Installs networking bridge utilities
# Allows creation of bridge interfaces (e.g., br0)
# Enables nested VMs to access the network/internet

# virtinst
# Provides virt-install command
# Used to create and configure virtual machines easily
# Helps deploy VMs from ISO or disk images

# cloud-image-utils
# Provides cloud-localds tool
# Used to create cloud-init configuration ISO files
# Helps automate VM user/password/network setup

