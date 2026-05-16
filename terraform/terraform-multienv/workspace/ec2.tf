#here we creating aws instance 
resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = lookup(var.instance_type, local.environment)  #here we are using lookup function to get the value of instance type based on the environment
  vpc_security_group_ids   =  [aws_security_group.allow_tls.id]  #here attaching sec group to ec2
  
  tags = {
    Name = "${var.project}-${local.environment}"
    project = "roboshop"
    Environment = local.environment
  }
}

#2.creating security group

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform"
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
    Name = "allow-all-terraform"
  }
}



