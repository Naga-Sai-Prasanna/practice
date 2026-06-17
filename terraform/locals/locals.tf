#locals {
  #instance_name = "${var.name}-${var.environment}" #locals-dev
#}

#now modify in ec2.tf


#if you don't want to override the variable value then you can use locals to define the variable and then use it in your code

locals {
  instance_name = "${var.name}-${var.environment}" #locals-dev
  instance_type = "t3.micro"
  common_tags ={

        project ="roboshop"
        Terraform = "true"
        environment = "dev"

    }

    ec2_final_tags = merge(local.common_tags, var.ec2_tags) #here we are merging the common tags with the ec2 specific tags and then we can use it in our code
    ami_id = data.aws_ami.joindevops.id 
}

