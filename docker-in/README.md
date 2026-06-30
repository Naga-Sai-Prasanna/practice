# Docker In

A practice repo covering Docker installation on AWS EC2, and a breakdown of every major Dockerfile instruction, written while learning Docker fundamentals.

## What This Covers

1. **Provisioning + installing Docker** on an EC2 instance using Terraform and a shell script
2. **Dockerfile instructions**, each broken into its own folder with a working example

## Part 1 — Instance Creation & Docker Installation

| File | Purpose |
|------|---------|
| `main.tf` | Terraform configuration provisioning the EC2 instance |
| `provider.tf` | AWS provider configuration |
| `docker.sh` | User-data script that extends the root volume and installs Docker |

### What `docker.sh` Does

- Extends the root volume from the default 20GB partition up to the full 50GB disk (`growpart`, `lvextend`, `xfs_growfs` on `/var`)
- Installs Docker CE, the CLI, `containerd.io`, the Buildx plugin, and the Compose plugin via the official Docker `dnf` repo
- Starts and enables the Docker service
- Adds `ec2-user` to the `docker` group, so Docker commands can be run without `sudo`

```bash
#!/bin/bash
sudo growpart /dev/nvme0n1 4
sudo lvextend -r -L+30G /dev/RootVG/varVol
sudo xfs_growfs /var

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user
```

#### Usage

```bash
terraform init
terraform apply
```

The script above runs automatically as EC2 user-data on instance launch. After it finishes, log out and back in (or start a new SSH session) for the `docker` group membership to take effect, then confirm:

```bash
docker run hello-world
```

## Part 2 — Dockerfile Instructions

The `dockerfiles/` folder contains one subfolder per Dockerfile instruction, each with a minimal working example demonstrating that instruction in isolation:

| Folder | Instruction |
|--------|-------------|
| `ADD/` | `ADD` — copy files into the image, with support for remote URLs and auto-extracting archives |
| `ARG/` | `ARG` — build-time variables |
| `CMD/` | `CMD` — default command run when a container starts |
| `COPY/` | `COPY` — copy local files into the image |
| `ENTRYPOINT/` | `ENTRYPOINT` — fixed executable a container always runs |
| `ENV/` | `ENV` — environment variables baked into the image |
| `EXPOSE/` | `EXPOSE` — documents the port(s) a container listens on |
| `FROM/` | `FROM` — base image selection |
| `LABEL/` | `LABEL` — metadata attached to the image |
| `ONBUILD/` | `ONBUILD` — triggers that fire when this image is used as a base for another build |
| `RUN/` | `RUN` — executes commands during the build |
| `USER/` | `USER` — sets the user the container runs as |
| `WORKDIR/` | `WORKDIR` — sets the working directory for subsequent instructions |

### Usage

From inside any instruction folder:

```bash
docker build -t example .
docker run example
```

## Status

This is a personal learning/practice repo for Docker fundamentals, building toward the optimized, multi-service setup in [`roboshop-docker`](https://github.com/Naga-Sai-Prasanna/roboshop-docker).