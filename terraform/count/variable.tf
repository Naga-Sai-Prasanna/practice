#here add this now ec2.tf refre this file.
variable "instances" {
  type = list
  default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend"]
}


#for r53 records add below:

variable "zone_id" {
  default = "Z00012023QHMSESC7X34Q"

}

variable "domain_name" {
  default = "prasanna.fun"

}


variable "fruits" {
  type = list(string)
  default = ["apple", "banana", "banana", "orange"]
}

variable "fruits_set" {
  type = set(string)
  default = ["apple", "banana", "banana", "orange"]
}
