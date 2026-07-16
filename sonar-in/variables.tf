variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "Existing EC2 Key Pair"
}

variable "domain_name" {
  description = "Root domain already hosted in Route 53 (e.g. prasanna.fun)"
  default     = "prasanna.fun"
}

variable "subdomain" {
  description = "Subdomain to create for SonarQube (e.g. sonarqube)"
  default     = "sonarqube"
}
