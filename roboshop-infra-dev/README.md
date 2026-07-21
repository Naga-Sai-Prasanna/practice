# RoboShop Infra Dev

**Role: Module User**

The environment-level Terraform configuration that provisions the full RoboShop **dev** environment by calling the reusable modules — VPC, security groups, and RoboShop components — in the correct order. This repo does not define any reusable module logic itself; it wires together and configures the module-developer repos for this specific environment.

## What This Provisions

A complete dev environment for the RoboShop application: networking, security, a bastion host, databases, load balancers, the application components themselves, TLS via ACM, a CDN, and a VPN endpoint for access — applied as a numbered sequence of steps.

## Folder Structure (applied in order)

| Folder | Purpose |
|--------|---------|
| `00-vpc/` | Calls [`terraform-aws-vpc`](https://github.com/Naga-Sai-Prasanna/terraform-aws-vpc) to provision the VPC, subnets, NAT, and routing |
| `10-sg/` | Calls [`terraform-aws-sg`](https://github.com/Naga-Sai-Prasanna/terraform-aws-sg) to create base security groups |
| `20-sg-rules/` | Adds detailed ingress/egress rules to the security groups created in `10-sg` |
| `30-bastion/` | Provisions a bastion host for secure access into the private network |
| `40-databases/` | Provisions the datastores (e.g. MySQL, MongoDB, Redis, RabbitMQ) |
| `50-backend-alb/` | Provisions the backend Application Load Balancer |
| `60-catalogue/` | Calls [`terraform-roboshop-component`](https://github.com/Naga-Sai-Prasanna/terraform-roboshop-component) to deploy the Catalogue service |
| `70-acm/` | Provisions an ACM certificate for TLS |
| `80-frontend-alb/` | Provisions the frontend Application Load Balancer |
| `90-components/` | Calls [`terraform-roboshop-component`](https://github.com/Naga-Sai-Prasanna/terraform-roboshop-component) for the remaining RoboShop services (cart, shipping, payment, user, frontend) |
| `95-cdn/` | Provisions a CDN in front of the frontend |
| `98-openvpn/` | Provisions an OpenVPN endpoint for environment access |

> Each numbered folder is a separate Terraform working directory, applied in numeric order since later steps depend on resources created by earlier ones.

## Prerequisites

- Terraform installed locally
- AWS CLI configured with credentials that have permission to create the relevant resources
- The module-developer repos this configuration depends on are referenced via Terraform's module `source`, so no manual setup of those repos is needed beyond having network access to fetch them

## Usage

Apply each numbered folder in order:

```bash
cd 00-vpc
terraform init
terraform apply

cd ../10-sg
terraform init
terraform apply

# ...continue through each numbered folder in sequence
```

Tear down in **reverse** order when done, to respect resource dependencies:

```bash
cd 98-openvpn
terraform destroy

cd ../95-cdn
terraform destroy

# ...continue backward through each folder
```

## How This Fits Into the Bigger Picture

This is the **module user** — the only repo in the set that actually gets applied directly against AWS. It consumes all three module-developer repos:

```
terraform-aws-vpc   ──┐
terraform-aws-sg    ──┼──>  roboshop-infra-dev  (this repo)
component-module    ──┘
```

- **[`terraform-aws-vpc`](https://github.com/Naga-Sai-Prasanna/terraform-aws-vpc)** — called in `00-vpc/`
- **[`terraform-aws-sg`](https://github.com/Naga-Sai-Prasanna/terraform-aws-sg)** — called in `10-sg/` and `20-sg-rules/`
- **[`terraform-roboshop-component`](https://github.com/Naga-Sai-Prasanna/terraform-roboshop-component)** — called in `60-catalogue/` and `90-components/`, once per RoboShop service

Everything else in this repo (`30-bastion`, `40-databases`, `50-backend-alb`, `70-acm`, `80-frontend-alb`, `95-cdn`, `98-openvpn`) is environment-specific infrastructure defined directly here, rather than pulled from a reusable module.

## Notes

- `terraform.tfstate` for this environment is currently tracked at the repo root — for a real dev/prod setup, consider moving to a remote backend (e.g. S3 + DynamoDB) instead of local state, to avoid state conflicts and accidental commits of sensitive data.