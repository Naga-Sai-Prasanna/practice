resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = var.ec2_tags
}

# sec group

resource "aws_security_group" "allow_tls" {
  name        =  var.sg_name # this is for aws
  description = var.sg_description
  
  egress {
    from_port = var.sg_from_port
    to_port = var.sg_to_port
    protocol = var.sg_protocol
    cidr_blocks = var.cidr_blocks
    ipv6_cidr_blocks = var.ipv6_cidr_blocks
  }

   ingress {
    from_port = var.sg_from_port
    to_port = var.sg_to_port
    protocol = var.sg_protocol
    cidr_blocks = var.cidr_blocks
    ipv6_cidr_blocks = var.ipv6_cidr_blocks
  }


  tags = var.sg_tags
  }







