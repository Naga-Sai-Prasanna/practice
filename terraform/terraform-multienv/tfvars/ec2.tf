#here we creating aws instance 
resource "aws_instance" "web" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = var.instance_type
  vpc_security_group_ids   =  [aws_security_group.allow_tls.id]  #here attaching sec group to ec2
  
  tags = {
    Name = "terraform-state-demo-${var.environment}"
    project = "roboshop"
  }
}

#2.creating security group

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform-${var.environment}"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-all-terraform-${var.environment}"
  }
}



