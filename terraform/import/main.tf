# skeleton resource

# resource "aws_instance" "import" {
#     }

# first in ec2 cretae a instance and after that write a skeletal form  like above.from cmd run terraform init and 
# terraform import aws_instance.import<instance-id> 
# Here we are saying terraform to import to the aws_instance.import from created ec2
# Now it shows import successfull and automatically state file will create.from terraform.tfstate file we have to copy the code based on our requirement
# we can add as below


#resource "aws_instance" "import" {
/*     instance_type = "t3.micro"
    ami = "ami-0220d79f3f480ecf5"
    vpc_security_grouo_ids = [
        "sg-07c8acf3fa6b923fa"
         ] #replace with your sec group
          
    subnet_id = "subnet-05ba31ef8fb5ba283"  #replace with subnet
    tags = {
        Name = "import-demo-change"
    }


} */

# if above format is too clumsy then run terraform fmt in cmd line so it will rearrange it.