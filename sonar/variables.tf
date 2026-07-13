variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (needs >=2GB RAM for SonarQube)"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

# variable "my_ip" {
#   description = "Your public IP in CIDR form, e.g. 1.2.3.4/32 (used to restrict SSH and port 9000 access)"
#   type        = list
# }

variable "sonar_db_password" {
  description = "Password for the sonar Postgres DB user"
  type        = string
  default     = "sonar"
  sensitive   = true
}
