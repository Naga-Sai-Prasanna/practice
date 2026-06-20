variable "environment" {
    type = string
    default = "dev"
   
  
}
variable "project" {
    type = string
    default = "roboshop"
  
}

variable "sg_names" {
    type = list
    default = [
        #databases
        "mongodb", "redis", "mysql", "rabbitmq",
        #backend
        "catalogue", "user", "cart", "shipping", "payment",
        #backend alb
        "backend_alb",
        # frontend
        "frontend",
        # forntend alb
        "frontend_alb",
        #bastion
        "bastion",
        #openvpn
        "openvpn"
    ]
}
