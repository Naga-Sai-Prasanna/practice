resource "aws_instance" "docker" {
    instance_type = "t3.micro"
    ami =  ami-0220d79f3f480ecf5
    vpc_security_group_ids = sg-06cf4cbd02e607cf6
    user_data = file("docker.sh")

    root_block_device {
      volume_size = 50
      volume_type = "gp3"
      # ebs volume tags
      tags = {
        name = "docker" 
        }

    }    
    tags = {
        Name = docker
        Project = roboshop
        Component = dev
    }
}   