#!/bin/bash

# we are creating 50gb root, but only 20gb is partitioned
# remaining 30gb we need to extend using below commands
sudo growpart /dev/nvme0n1 4
sudo lvextend -r -L+30G /dev/RootVG/varVol
sudo xfs_growfs /var 


sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo  systemctl enable docker

sudo usermod -aG docker ec2-user

#eksctl
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

eksctl version

#kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl
chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

kubectl version --client

cd ~

cd ~

# Clone kubectx with retry logic (handles transient network failures)
rm -rf ~/.kubectx
for i in 1 2 3; do
    git clone https://github.com/ahmetb/kubectx.git ~/.kubectx && break
    echo "Clone attempt $i failed, retrying..."
    sleep 3
done

# Verify the clone actually succeeded before symlinking
if [ ! -f ~/.kubectx/kubectx ] || [ ! -f ~/.kubectx/kubens ]; then
    echo "ERROR: kubectx clone failed or incomplete. Aborting."
    exit 1
fi

sudo ln -sf ~/.kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf ~/.kubectx/kubens /usr/local/bin/kubens

COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
sudo ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
sudo ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens

export PATH=~/.kubectx:$PATH

# Confirm install worked
<<<<<<< HEAD
which kubectx && which kubens && echo "kubectx/kubens installed successfully"
=======
which kubectx && which kubens && echo "kubectx/kubens installed successfully"
>>>>>>> d3ae85eb04072b1828f42f1434c42649291157bf
