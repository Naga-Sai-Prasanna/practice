variable "common_tags" {
    default = {
        project ="roboshop"
        Terraform = "true"
        environment = "dev"

    }
}

variable "ec2_tags" {
    default = {
        Name = "functions-demo"
       # environment = "prod". -- if we want to replace the the previous value just give same vkeyname.

        
    }
}

variable "sg_tags" {
    default = {
      Name = "functions-demo"
        
    }
}


variable "instances" {
  type = list
  default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend"]
}
