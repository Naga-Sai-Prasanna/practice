# Kubernetes RBAC on Amazon EKS

## Overview

This project demonstrates how to implement **Role-Based Access Control (RBAC)** in an Amazon EKS cluster by integrating **AWS IAM** with Kubernetes authentication and authorization.

The project covers namespace-level access, cluster-level access, IAM user mapping using the `aws-auth` ConfigMap, and secure AWS resource access using **IAM Roles for Service Accounts (IRSA)**.

---

## Architecture

```
                 AWS IAM
                    │
                    │
             IAM User / IAM Role
                    │
                    ▼
            aws-auth ConfigMap
                    │
          (Authentication)
                    │
                    ▼
      Kubernetes RBAC (Authorization)
                    │
      ┌─────────────┴─────────────┐
      │                           │
 Namespace Roles            Cluster Roles
      │                           │
      ▼                           ▼
 Kubernetes Resources      Cluster Resources
```

---

## Project Structure

```
k8s-rbac/
│
├── 01-role.yaml
├── 02-rolebinding.yaml
├── 03-aws-auth.yaml
├── 04-roboshop-admin.yaml
├── 05-roboshop-admin-rb.yaml
├── 06-trainee-role-binding.yaml
├── 07-sa.yaml
├── 08-pod.yaml
└── README.md
```

---

## Features

- Integrate AWS IAM users with Amazon EKS
- Configure Kubernetes RBAC
- Namespace-level access using Roles
- Cluster-level access using ClusterRoles
- Group-based authorization
- IAM Roles for Service Accounts (IRSA)
- Secure access to AWS Secrets Manager from Kubernetes Pods

---

## Prerequisites

- AWS Account
- Amazon EKS Cluster
- kubectl
- AWS CLI
- eksctl

---

## Authentication

Authentication is handled by AWS IAM.

The workflow is:

1. Create an IAM User.
2. Attach an IAM policy with `eks:DescribeCluster` permission.
3. Map the IAM user in the `aws-auth` ConfigMap.
4. Update kubeconfig using AWS CLI.
5. Authenticate to the EKS cluster using `kubectl`.

---

## Authorization

After authentication, Kubernetes RBAC determines what the user can access.

This project demonstrates:

- Role
- RoleBinding
- ClusterRole
- ClusterRoleBinding
- Group-based RoleBinding

Example permissions include:

- Read Pods
- Deploy Applications
- Cluster Resource Access

---

## IAM Roles for Service Accounts (IRSA)

Instead of storing AWS credentials inside Pods, this project uses **IRSA**.

The flow is:

```
Pod
 │
 ▼
Service Account
 │
 ▼
IAM Role
 │
 ▼
AWS Secrets Manager
```

The Service Account is associated with an IAM Role, allowing Pods to securely access AWS services without storing long-term credentials.

---

## Deployment

Apply the RBAC manifests:

```bash
kubectl apply -f 01-role.yaml
kubectl apply -f 02-rolebinding.yaml
kubectl apply -f 03-aws-auth.yaml
kubectl apply -f 04-roboshop-admin.yaml
kubectl apply -f 05-roboshop-admin-rb.yaml
kubectl apply -f 06-trainee-role-binding.yaml
kubectl apply -f 07-sa.yaml
kubectl apply -f 08-pod.yaml
```

---

## Verification

Verify Roles:

```bash
kubectl get roles -n roboshop
```

Verify RoleBindings:

```bash
kubectl get rolebindings -n roboshop
```

Verify Service Accounts:

```bash
kubectl get sa -n roboshop
```

Verify Pods:

```bash
kubectl get pods -n roboshop
```

---

## Technologies Used

- Amazon EKS
- Kubernetes
- AWS IAM
- AWS CLI
- eksctl
- RBAC
- IAM Roles for Service Accounts (IRSA)

---

## Key Learnings

- Integrated AWS IAM with Amazon EKS.
- Implemented namespace-level and cluster-level RBAC.
- Managed user access using Roles and RoleBindings.
- Used groups to simplify access management.
- Configured IRSA to securely access AWS Secrets Manager.
- Understood the authentication and authorization workflow in Kubernetes.

---

## Author

**Prasanna**

AWS | Kubernetes | Docker | Terraform | Jenkins | DevOps