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
# sudo apt update -y

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
 
 


#!/bin/bash

set -e
export DEBIAN_FRONTEND=noninteractive

echo "===== Waiting for cloud-init to finish ====="
cloud-init status --wait || true

echo "===== Cleaning APT cache ====="
rm -rf /var/lib/apt/lists/*
apt-get clean

echo "===== Updating system ====="
apt-get update -y

echo "===== Installing KVM & Required Packages ====="
apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    virtinst \
    bridge-utils \
    cloud-image-utils \
    wget

echo "===== Enabling & Starting libvirtd ====="
systemctl enable libvirtd
systemctl start libvirtd

echo "===== Adding user to libvirt group ====="
usermod -aG libvirt imskadmin

echo "===== Creating directory for Nested VM ====="
VM_DIR="/var/lib/libvirt/images/nestedvm"
mkdir -p $VM_DIR
cd $VM_DIR

echo "===== Downloading Ubuntu Cloud Image ====="
wget -q https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

echo "===== Creating QCOW2 Disk ====="
qemu-img create -f qcow2 \
    -b jammy-server-cloudimg-amd64.img \
    -F qcow2 \
    nestedvm.qcow2 20G

echo "===== Creating Cloud-Init user-data ====="
cat <<EOF > user-data
#cloud-config
password: ubuntu
chpasswd:
  expire: False
ssh_pwauth: True
EOF

echo "===== Creating Seed ISO ====="
cloud-localds seed.iso user-data

echo "===== Creating Nested VM using virt-install ====="
virt-install \
    --name nestedvm \
    --memory 2048 \
    --vcpus 2 \
    --disk nestedvm.qcow2 \
    --disk seed.iso,device=cdrom \
    --os-variant ubuntu22.04 \
    --virt-type kvm \
    --graphics none \
    --network network=default \
    --import \
    --noautoconsole

echo "===== Enabling VM Autostart ====="
virsh autostart nestedvm

echo "Nested VM Installed Successfully" > /root/nestedvm-install.log
echo "===== Installation Completed Successfully ====="

