
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
  
  vpc_security_group_ids   =  [aws_security_group.allow_tls.id]  
  
  tags = var.ec2_tags
  
}



resource "aws_security_group" "allow_tls" {
  name        = var.sg_name
  description = var.sg_description

  ingress {
    from_port        = var.sg_from_port
    to_port          = var.sg_to_port
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = var.sg_from_port
    to_port          = var.sg_to_port
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.sg_tags
    
  }

variable "ec2_tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-00000000"
}

variable "sg_description" {
  description = "Description for the security group"
  type        = string
  default     = "Allow TLS traffic"
}

variable "sg_name" {
  description = "Name for the security group"
  type        = string
  default     = "allow_tls_sg"
}

variable "sg_from_port" {
  description = "Starting port for the security group rule"
  type        = number
  default     = 443
}

variable "sg_to_port" {
  description = "Ending port for the security group rule"
  type        = number
  default     = 443
}

variable "sg_tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

variable "cidr_blocks" {
  description = "CIDR blocks allowed for ingress and egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
