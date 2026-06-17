# here we are adding dev variable for dev we are using t3.micro otherwise t3.small
variable "environment" {
    type = string
    default = "dev"  #if we change to prod then result shows t3 small
}

variable "ami_id" {
   type     =   string
   default  =  "ami-0220d79f3f480ecf5"
   description =  "RHEL 9 image"

}

variable "instance_type" {
   type     =   string
   default  =  "t3.micro"

}

variable "ec2_tags" {
    type = map
    default = { 
        Name = "terraform"
        Project = "variables-demo"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "sg_name" {
    type = string
    default = "allow-all-terraform"
}

variable "sg_description" {
    default =  "Allow all inbound and outbound traffic"
}
variable "sg_from_port" {
    type = number
    default =  0
}

variable "sg_to_port" {
    type = number
    default =  0
}

variable "cidr_blocks" {
    type = list
    default =  ["0.0.0.0/0"]
}

variable "sg_tags" {
    type =  map
    default =  {
    Name = "allow-all-terraform"
    Project  =  "variables-demo"
    Terraform   =  "true"
    Environment =  "dev"
}
}


variable "ec2_tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-00000000"
}

variable "sg_description" {
  description = "Description for the security group"
  type        = string
  default     = "Allow TLS traffic"
}

variable "sg_name" {
  description = "Name for the security group"
  type        = string
  default     = "allow_tls_sg"
}

variable "sg_from_port" {
  description = "Starting port for the security group rule"
  type        = number
  default     = 443
}

variable "sg_to_port" {
  description = "Ending port for the security group rule"
  type        = number
  default     = 443
}

variable "sg_tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

variable "cidr_blocks" {
  description = "CIDR blocks allowed for ingress and egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
