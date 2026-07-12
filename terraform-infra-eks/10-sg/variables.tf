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
        "ingress_alb",
        #bastion
        "bastion",
        #openvpn
        "openvpn",
        "eks_control_plane",
        "eks_node",
        "jenkins",
        "jenkins_agent",
        "sonar","runner"
    ]
}
