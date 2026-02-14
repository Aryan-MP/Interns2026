#!/bin/bash
set -e

echo "Installing KVM & dependencies..."
apt update -y
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cloud-image-utils

systemctl enable libvirtd
systemctl start libvirtd

echo "Creating shared directory..."
mkdir -p /shared-data
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
 --disk path=/var/lib/libvirt/images/inner-vm.qcow2,format=qcow2 \
 --disk path=/var/lib/libvirt/images/seed.img,device=cdrom \
 --network network=default \
 --filesystem /shared-data,shared-data,mode=mapped \
 --os-variant ubuntu22.04 \
 --import \
 --noautoconsole

echo "Nested VM created successfully."
