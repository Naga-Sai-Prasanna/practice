
resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids   =  [aws_security_group.allow_tls.id] 


  #provisioners executed in orders.and self is the special var
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory.ini" #here we are using self to get the public ip of the instance and then we are writing it to inventory.ini file which can be used for ansible inventory file.
  }

provisioner "local-exec" {
    command = "exit 1" #here we are exiting with code 1 to simulate the failure of the provisioner and then we can see the effect of the failure in the terraform apply command."
    on_failure = continue #here we are using on_failure to continue the execution of the next provisioner even if the previous provisioner fails. by default it will stop the execution of the next provisioner if the previous provisioner fails.
   
   }
 
   
 provisioner "local-exec" {
     command = "echo-script"
   }
 
 provisioner "local-exec" {
        when = destroy
        command = "echo 'Deleting the instance'" #we have to empty the 
   }

 provisioner "local-exec" {
        when = destroy
        command = "echo > inventory.ini"
   
 }

  connection { #helps to connect to the instance and run the commands in the remote-exec provisioner. here we are using ssh connection to connect to the instance and then we are running the commands in the remote-exec provisioner.
    type = "ssh"
    user ="ec2-user" 
    password = "DevOps321" 
    host = self.public_ip

  }
#here 
provisioner "remote-exec" { # terraform will take the connection details later in this var it run below cmds.
    inline = [
        "sudo dnf install nginx -y",
        "sudo systemctl start nginx" ]

}   

provisioner "remote-exec" { # terraform will take the connection details later in this var it run below cmds.
    inline = [ #one_after_one exection
        "sudo systemctl stop nginx"
         ]        
     when = destroy   
}

  tags = {
    Name = "provisioners-demo"
    Project = "roboshop"
  }
  }



  #here attaching sec group to ec2
  
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

  

  
      

