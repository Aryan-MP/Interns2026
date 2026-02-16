bash -c '
exec > /var/log/nested-vm-setup.log 2>&1
set -e

log(){ echo \"[$(date +%T)] $*\"; }

log \"=== START Nested VM Setup ===\"

# ------------------------------
# Wait for cloud-init & apt
# ------------------------------
cloud-init status --wait || true
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virtinst \
  nginx \
  curl \
  cloud-image-utils

systemctl enable libvirtd
systemctl start libvirtd

# ------------------------------
# Ensure default network active
# ------------------------------
if ! virsh net-info default | grep -q \"Active:.*yes\"; then
    virsh net-start default
    virsh net-autostart default
fi

# ------------------------------
# Prepare image paths
# ------------------------------
IMG_DIR=/var/lib/libvirt/images
CLOUD_IMG=$IMG_DIR/ubuntu-base.img
INNER_DISK=$IMG_DIR/inner-vm.qcow2
SEED_ISO=$IMG_DIR/seed.iso
CIDIR=$IMG_DIR/cloud-init

mkdir -p $CIDIR

# ------------------------------
# Download Ubuntu cloud image
# ------------------------------
if [ ! -f \"$CLOUD_IMG\" ]; then
    curl -fSL -o \"$CLOUD_IMG\" \
    https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
fi

# ------------------------------
# Create inner disk
# ------------------------------
if [ ! -f \"$INNER_DISK\" ]; then
    qemu-img create -f qcow2 -F qcow2 -b \"$CLOUD_IMG\" \"$INNER_DISK\" 10G
fi

# ------------------------------
# Create cloud-init files
# ------------------------------
cat > $CIDIR/user-data <<EOF
#cloud-config
hostname: inner-vm
manage_etc_hosts: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: ChangeMe123!
packages:
  - nginx
package_update: true
write_files:
  - path: /var/www/html/index.html
    owner: www-data:www-data
    permissions: \"0644\"
    content: |
      <h1>Hello from Nested VM</h1>
      <h2>Himanshu Malik</h2>
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
EOF

cat > $CIDIR/meta-data <<EOF
instance-id: inner-vm-001
local-hostname: inner-vm
EOF

cloud-localds \"$SEED_ISO\" \"$CIDIR/user-data\" \"$CIDIR/meta-data\"

# ------------------------------
# Create VM only if not exists
# ------------------------------
if ! virsh dominfo inner-vm >/dev/null 2>&1; then
    virt-install \
      --name inner-vm \
      --ram 2048 \
      --vcpus 2 \
      --cpu host \
      --disk path=\"$INNER_DISK\",format=qcow2 \
      --disk path=\"$SEED_ISO\",device=cdrom \
      --os-variant ubuntu22.04 \
      --network network=default \
      --graphics none \
      --noautoconsole \
      --import
fi

# ------------------------------
# Wait for inner VM IP
# ------------------------------
sleep 20

INNER_IP=$(virsh domifaddr inner-vm | awk \"/ipv4/ {print \\$4}\" | cut -d/ -f1)

log \"Detected inner VM IP: $INNER_IP\"

# ------------------------------
# Configure Reverse Proxy
# ------------------------------
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default

cat > /etc/nginx/sites-available/reverse-proxy.conf <<EOF
server {
    listen 80 default_server;
    server_name _;

    location / {
        proxy_pass http://$INNER_IP;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/reverse-proxy.conf \
       /etc/nginx/sites-enabled/reverse-proxy.conf

nginx -t
systemctl restart nginx

log \"=== Nested VM Setup COMPLETE ===\"
'
