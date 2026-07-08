
variable "environment" {
    type = string
    default = "Dev"
   
  
}
variable "project" {
    type = string
    default = "roboshop"
  
}



variable "zone_id" {
  default = "Z00012023QHMSESC7X34Q"

}

variable "domain_name" {
  default = "prasanna.fun"

}


variable "component" {

    type = string 
}

variable "health_check_path" {
    default = "/health"
  
}
variable "port_number" {
    default = 8080
}

variable "app_version" {
  type = string
  default = "v3"
}

variable "rule_priority" {
  type = number
  
}