terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the latest Ubuntu 22.04 AMI
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
  description = "Allow SSH and SonarQube UI access from my IP only"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
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

  user_data = templatefile("${path.module}/user_data.sh", {
    sonar_db_password = var.sonar_db_password
  })

  tags = {
    Name = "sonarqube-practice"
  }
}

output "public_ip" {
  description = "Public IP of the SonarQube instance"
  value       = aws_instance.sonarqube.public_ip
}

output "sonarqube_url" {
  description = "URL to access SonarQube once it's finished booting (~3-5 min)"
  value       = "http://${aws_instance.sonarqube.public_ip}:9000"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i prasanna.pem ubuntu@${aws_instance.sonarqube.public_ip}"
}

resource "aws_eip" "sonarqube_eip" {
  instance = aws_instance.sonarqube.id
  domain   = "vpc"

  tags = {
    Name = "sonarqube-eip"
  }
}

output "elastic_ip" {
  value = aws_eip.sonarqube_eip.public_ip
}


data "aws_route53_zone" "main" {
  name         = "prasanna.fun"   # replace with your actual domain, must end in a dot-free root, Route53 matches internally
  private_zone = false
}

resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "sonarqube.prasanna.fun"   # the subdomain you want
  type    = "A"
  ttl     = 300
  records = [aws_eip.sonarqube_eip.public_ip]
}

output "sonarqube_dns" {
  value = "http://${aws_route53_record.sonarqube.name}:9000"
}