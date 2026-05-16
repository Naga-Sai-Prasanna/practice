#here we creating aws instance 
resource "aws_instance" "example" {
  ami                    = "ami-0220d79f3f480ecf5"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id] #here attaching sec group to ec2

  tags = {
    Name    = "terraform"
    project = "roboshop"
  }
}

#2.creating security group

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
  description = "Allow all inbound and outbound traffic"


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # dynamic ingress --ingress is going to be specia var and here it took ingress.value and ingress.key as the same.

  dynamic "ingress" {
    for_each = var.ingress_rules #here you can write to_set
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  tags = {
    Name = "allow-all-terraform"
  }
}



