data "aws_ami" "joindevops" {
  most_recent = true
  owners = ["973714476881"]

  filter {
    name   = "name"
    values = ["RedHat-9-DevOps-Practice"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# # i dont have ami i used trainer details don't pply it just plan
# output:
  # aws_instance.web will be created
  # + resource "aws_instance" "web" {
  #     + ami                                  = "ami-0220d79f3f480ecf5"
  #     + arn  
  
  #ex:-2 querying the data from manually created instance
  
  data "aws_instance" "terraform_instance" {
      instance_id = "i-0c625d3ff530eeb0b"  
     # here we are giving instance id of manually created instance
  
  }