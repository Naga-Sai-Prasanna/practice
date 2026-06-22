resource "aws_security_group" "eksctl" {
  name        = "eksctl-sg"
  description = "Allow SSH and HTTP on 80 and 8080"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "eksctl-sg"
    Project   = "roboshop"
    Component = "dev"
  }
}
resource "aws_instance" "docker" {
  instance_type = "t3.micro"
  ami           = "ami-0220d79f3f480ecf5"

  vpc_security_group_ids = [aws_security_group.eksctl.id]

  user_data = file("install.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"

    tags = {
      Name = "workstation"
    }
  }

  tags = {
    Name      = "workstation"
    Project   = "roboshop"
    Component = "dev"
  }
}