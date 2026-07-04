#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log) 2>&1

# ---- Grow root volume ----
# we are creating 50gb root, but only 20gb is partitioned
# remaining 30gb we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L+30G /dev/RootVG/varVol
xfs_growfs /var

# ---- Docker ----
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# ---- eksctl ----
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
eksctl version

# ---- kubectl (installed system-wide, not $HOME) ----
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl
chmod +x ./kubectl
install -m 0755 ./kubectl /usr/local/bin/kubectl
rm ./kubectl
kubectl version --client

# ---- kubectx / kubens (installed system-wide, not root's $HOME) ----
rm -rf /opt/kubectx
for i in 1 2 3; do
    git clone https://github.com/ahmetb/kubectx.git /opt/kubectx && break
    echo "Clone attempt $i failed, retrying..."
    sleep 3
done

if [ ! -f /opt/kubectx/kubectx ] || [ ! -f /opt/kubectx/kubens ]; then
    echo "ERROR: kubectx clone failed or incomplete. Aborting."
    exit 1
fi

ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

COMPDIR=$(pkg-config --variable=completionsdir bash-completion || echo /etc/bash_completion.d)
mkdir -p "$COMPDIR"
ln -sf /opt/kubectx/completion/kubectx.bash "$COMPDIR/kubectx"
ln -sf /opt/kubectx/completion/kubens.bash "$COMPDIR/kubens"

# ---- k9s ----
curl -sL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz" -o /tmp/k9s.tar.gz
tar -xzf /tmp/k9s.tar.gz -C /tmp
install -m 0755 /tmp/k9s /usr/local/bin/k9s
rm -f /tmp/k9s.tar.gz /tmp/k9s /tmp/LICENSE /tmp/README.md

# ---- Final verification ----
echo "===== Version check ====="
kubectl version --client
eksctl version
kubectx || true
kubens || true
k9s version
echo "===== user-data script completed successfully ====="