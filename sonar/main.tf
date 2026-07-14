terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- Auto-detect your current public IP (used to lock down SSH/9000 access) ---
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}

# --- Latest Ubuntu 22.04 AMI ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube-practice-sg"
  description = "Allow SSH and SonarQube UI access from my IP and Jenkins agent only"

  ingress {
    description = "SSH - my laptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "SonarQube UI - my laptop"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "SonarQube UI - Jenkins agent"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_ip]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sonarqube-practice-sg"
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    sonar_db_password  = var.sonar_db_password
    jenkins_webhook_url = var.jenkins_webhook_url
  })

  tags = {
    Name = "sonarqube-practice"
  }
}

# --- Elastic IP so the address survives every stop/start ---
resource "aws_eip" "sonarqube_eip" {
  instance = aws_instance.sonarqube.id
  domain   = "vpc"

  tags = {
    Name = "sonarqube-eip"
  }
}

# --- Route53 record pointing your subdomain at the Elastic IP ---
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "sonarqube.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.sonarqube_eip.public_ip]
}

output "public_ip" {
  description = "Elastic IP of the SonarQube instance (static, survives stop/start)"
  value       = aws_eip.sonarqube_eip.public_ip
}

output "sonarqube_url_ip" {
  description = "SonarQube URL via IP"
  value       = "http://${aws_eip.sonarqube_eip.public_ip}:9000"
}

output "sonarqube_url_dns" {
  description = "SonarQube URL via DNS"
  value       = "http://sonarqube.${var.domain_name}:9000"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i <path-to-your-key> ubuntu@${aws_eip.sonarqube_eip.public_ip}"
}
