variable "name" {
  type    = string
  default = "locals"
}
variable "environment" {
  type    = string
  default = "dev"
}
#if we run below code it will give error because we are using variable name before defining it so we need to use locals to define the variable and then we can use it in our code
# variable "instance_name" {
#   type = string
#   default     = "${var.name}-${var.environment}"  #locals-dev
# }



variable "ec2_tags" {
    default = {
        Name = "locals-demo" #anybody can chanage the vvalue 
      #  environment = "prod" -- if we want to replace the the previous value just give same keyname.

        
    }
}

variable "sg_tags" {
    default = {
      Name = "locals-demo"
        
    }
}
