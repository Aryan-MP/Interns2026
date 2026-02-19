# #!/bin/bash

# set -e

# ### VARIABLES ###
# ISO_URL="https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"

# ISO_NAME="ubuntu-22.04.iso"
# VM_NAME="nested-ubuntu"
# RAM_MB=2048
# VCPUS=2
# DISK_SIZE=20G
# VM_USER="devopsuser"
# VM_PASS="Devops@123"

# # echo "==== Updating system ===="
# # sudo apt update -y

# echo "==== Installing KVM Hypervisor ===="
# sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virtinst bridge-utils

# echo "==== Enabling libvirtd ===="
# sudo systemctl enable libvirtd
# sudo systemctl start libvirtd

# echo "==== Adding current user to libvirt group ===="
# sudo usermod -aG libvirt $(whoami)

# echo "==== Downloading Ubuntu ISO ===="
# wget -O $ISO_NAME $ISO_URL

# echo "==== Creating disk image ===="
# sudo qemu-img create -f qcow2 /var/lib/libvirt/images/$VM_NAME.qcow2 $DISK_SIZE

# echo "==== Creating cloud-init config ===="
# mkdir -p cloud-init

# cat > cloud-init/user-data <<EOF
# #cloud-config
# users:
#   - name: $VM_USER
#     sudo: ALL=(ALL) NOPASSWD:ALL
#     groups: sudo
#     shell: /bin/bash
#     lock_passwd: false
#     passwd: $(openssl passwd -1 $VM_PASS)
# ssh_pwauth: True
# disable_root: false
# EOF

# cat > cloud-init/meta-data <<EOF
# instance-id: $VM_NAME
# local-hostname: $VM_NAME
# EOF

# cloud-localds cloud-init.iso cloud-init/user-data cloud-init/meta-data

# echo "==== Creating and Starting VM ===="
# sudo virt-install \
#   --name $VM_NAME \
#   --ram $RAM_MB \
#   --vcpus $VCPUS \
#   --disk path=/var/lib/libvirt/images/$VM_NAME.qcow2,format=qcow2 \
#   --disk path=cloud-init.iso,device=cdrom \
#   --cdrom $ISO_NAME \
#   --os-type linux \
#   --os-variant ubuntu22.04 \
#   --network network=default \
#   --graphics none \
#   --console pty,target_type=serial \
#   --noautoconsole

# echo "==== VM Created Successfully ===="
# echo "Connect using:"
# echo "sudo virsh console $VM_NAME"




#!/bin/bash
set -e

# VARIABLES
ISO_NAME="/var/lib/libvirt/images/ubuntu-22.04.5-live-server-amd64.iso"
VM_NAME="nested-ubuntu"
RAM_MB=2048
VCPUS=2
DISK_SIZE=20G
VM_USER="devopsuser"
VM_PASS="Devops@123"


# INSTALL KVM
echo "==== Installing KVM Hypervisor ===="
# sudo apt update -y
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virtinst bridge-utils cloud-image-utils

echo "==== Enabling libvirtd ===="
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

echo "==== Adding current user to libvirt group ===="
sudo usermod -aG libvirt $(whoami)


# CLEAN OLD VM IF EXISTS
echo "==== Cleaning old VM (if exists) ===="
sudo virsh destroy $VM_NAME 2>/dev/null || true
sudo virsh undefine $VM_NAME --remove-all-storage 2>/dev/null || true
sudo rm -f /var/lib/libvirt/images/$VM_NAME.qcow2
sudo rm -f /var/lib/libvirt/images/cloud-init.iso


# CREATE DISK
echo "==== Creating disk image ===="
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/$VM_NAME.qcow2 $DISK_SIZE


# CREATE CLOUD INIT CONFIG
echo "==== Creating cloud-init config ===="
mkdir -p cloud-init

cat > cloud-init/user-data <<EOF
#cloud-config
users:
  - name: $VM_USER
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: $(openssl passwd -1 $VM_PASS)

ssh_pwauth: True
disable_root: false
chpasswd:
  expire: false
EOF

cat > cloud-init/meta-data <<EOF
instance-id: $VM_NAME
local-hostname: $VM_NAME
EOF

sudo cloud-localds /var/lib/libvirt/images/cloud-init.iso cloud-init/user-data cloud-init/meta-data


# CREATE & START VM
echo "==== Creating and Starting VM ===="
sudo virt-install \
  --name $VM_NAME \
  --ram $RAM_MB \
  --vcpus $VCPUS \
  --disk path=/var/lib/libvirt/images/$VM_NAME.qcow2,format=qcow2 \
  --disk path=/var/lib/libvirt/images/cloud-init.iso,device=cdrom \
  --cdrom $ISO_NAME \
  --os-variant ubuntu22.04 \
  --network network=default \
  --graphics none \
  --console pty,target_type=serial \
  --noautoconsole

# Created Successfully
echo "VM Created Successfully "

