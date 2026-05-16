resource "aws_instance" "web" {
  for_each = var.instances
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = each.value
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = each.key
    Project = "Roboshop"
  }
}

# sec group

resource "aws_security_group" "allow_tls" {
  name        = "allow_all-terraform" # this is for aws
  description = "Allow TLS inbound traffic and all outbound traffic"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  tags = {
    Name = "allow_all-terraform"
  }
}







