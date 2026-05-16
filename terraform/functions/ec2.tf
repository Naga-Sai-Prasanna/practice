resource "aws_instance" "example" {
  #count = 10 instaed of we are saying terraform to create 10.terraform itself can check and create.
  count = length(var.instances) #here we are saying to create as many as the length of the list of instances in variable.tf
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids   =  [aws_security_group.allow_tls.id]  #here attaching sec group to ec2
  
  tags = merge {
 
   var.common_tags,
   var.ec2_tags
  }
}



resource "aws_security_group" "allow_tls" {
  name        = "allow-all-roboshop"  #this is for aws name
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

  
   
  tags = merge {
    var.common_tags,
       var.ec2_tags
  }
}


#if you run alone this you will see 10 instances and sec group but all having same name roboshop. so, we have to create variable.tf here we have to declare the var names.