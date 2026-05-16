variable "ingress_rules" {
  default = [
    {
      port   = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "allowing port number 22 from internet"
    },
    {
      port   = 443
      cidr_blocks = ["0.0.0.0/0"]
      description = "allowing port number 443 from internet"
    },

    {
      port   = 3306
      cidr_blocks = ["0.0.0.0/0"]
      description = "allowing port number 3306 from internet"
    }
  ]
}
    

    #here if we want to give from_port then in the ec2.tf also we have to give ingress.value.from_port for to and from ports.