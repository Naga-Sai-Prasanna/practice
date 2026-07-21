# Kubernetes on Amazon EKS (EKS)

## Overview

This repository contains hands-on Kubernetes manifests and examples built on **Amazon Elastic Kubernetes Service (EKS)**. It covers Kubernetes fundamentals, workload management, networking, configuration management, and deployment strategies through practical YAML examples.

The project is designed to provide a complete learning path from creating an EKS cluster to deploying production-ready workloads.

---

## Architecture

```text
                    Developer
                        │
                        ▼
                   GitHub Repository
                        │
                        ▼
                  EC2 Workstation
                        │
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
   Docker Build                  Kubernetes Manifests
        │
        ▼
     Amazon ECR
        │
        ▼
     Amazon EKS
        │
        ▼
   Worker Node Group
        │
        ▼
        Pods
```

---

## Repository Structure



```text
k8-resources/
├── 01-namespace.yaml
├── 02-pod.yaml
├── 03-multi-container.yaml
├── 04-labels.yaml
├── 05-annotations.yaml
├── 06-resources.yaml
├── 07-env.yaml
├── 08-configmap.yaml
├── 09-pod-configmap.yaml
├── 10-secrets.yaml
├── 11-pod-secret.yaml
├── 12-service.yaml
├── 13-service-test.yaml
├── 14-service-nodeport.yaml
├── 15-service-loadbalancer.yaml
├── 16-replicaset.yaml
├── 17-deployment.yaml
│
└── volumes/
    ├── 01-empty-dir.yaml
    ├── 02-host-path.yaml
    ├── 03-ebs-static.yaml
    ├── 04-ebs-storageclass.yaml
    ├── 05-ebs-dynamic.yaml
    ├── 06-efs-static.yaml
    ├── 07-efs-storageclass.yaml
    └── 08-efs-dynamic.yaml

---

## Features

- Amazon EKS Cluster Setup
- Kubernetes YAML Manifests
- Namespace Management
- Pod & Multi-Container Pods
- Labels & Annotations
- Environment Variables
- ConfigMaps
- Secrets
- Resource Requests & Limits
- ClusterIP Services
- NodePort Services
- LoadBalancer Services
- ReplicaSets
- Deployments
- Rolling Updates
- Rollbacks
- Service Discovery
- Pod-to-Pod Communication



```markdown
- Kubernetes Volume Management
- Ephemeral Volumes
- emptyDir Volume
- HostPath Volume
- Sidecar Container Pattern
- Persistent Volumes (PV)
- Persistent Volume Claims (PVC)
- Storage Classes
- AWS EBS Static Provisioning
- AWS EBS Dynamic Provisioning
- AWS EFS Static Provisioning
- AWS EFS Dynamic Provisioning
- Kubernetes Storage Integration with AWS

---

## Prerequisites

- AWS Account
- Docker
- AWS CLI
- kubectl
- eksctl
- Git

---

## Create EKS Cluster

```bash
eksctl create cluster --config-file=eks.yaml
```

Verify the cluster:

```bash
kubectl get nodes
```

---

## Deploy Resources

Deploy any Kubernetes manifest:

```bash
kubectl apply -f <manifest-file>.yaml
```

Example:

```bash
kubectl apply -f 01-namespace.yaml

kubectl apply -f 02-pod.yaml

kubectl apply -f 12-service.yaml
```

---

## Useful Commands

List resources

```bash
kubectl get pods

kubectl get svc

kubectl get deployment

kubectl get rs

kubectl get ns
```

Describe resources

```bash
kubectl describe pod <pod-name>

kubectl describe svc <service-name>
```

Execute inside a Pod

```bash
kubectl exec -it <pod-name> -- bash
```

Deployment Rollback

```bash
kubectl rollout history deployment/nginx

kubectl rollout undo deployment/nginx
```

---

## Learning Outcomes

This repository demonstrates:

- Kubernetes Architecture
- Amazon EKS
- Kubernetes Resources
- YAML Manifest Creation
- Kubernetes Networking
- Configuration Management
- Service Discovery
- Application Deployment
- Rolling Updates
- Rollbacks
- Kubernetes Best Practices

---

## Best Practices

- Use persistent storage for stateful applications.
- Use emptyDir for temporary Pod-level shared storage.
- Avoid exposing hostPath volumes unless required.
- Use PersistentVolumeClaims instead of directly managing storage inside Pods.
- Prefer dynamic provisioning using StorageClasses for cloud environments.
- Use EBS for low-latency block storage workloads.
- Use EFS for shared filesystem requirements across multiple Pods.

---

## Technologies Used

- Kubernetes
- Amazon EKS
- Docker
- Amazon ECR
- AWS CLI
- kubectl
- eksctl
- YAML

---

## Author

**Prasanna**

AWS | Kubernetes | Docker | Terraform | Jenkins | DevOps