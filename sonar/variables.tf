variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is Free Tier eligible; SonarQube needs the swap file (added automatically) to run on its 1GB RAM."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "sonar_db_password" {
  description = "Password for the sonar Postgres DB user"
  type        = string
  default     = "sonar"
  sensitive   = true
}

variable "domain_name" {
  description = "Root domain already hosted in Route53 (e.g. prasanna.fun). The record sonarqube.<domain_name> is created automatically."
  type        = string
}

variable "jenkins_ips" {
  description = "Public IPs (CIDR form) that need to reach SonarQube on port 9000 — typically both the Jenkins controller/master AND the Jenkins agent, since they can be on different instances/VPCs with different public IPs. e.g. [\"98.92.36.63/32\", \"34.232.44.246/32\"]"
  type        = list(string)
}

variable "jenkins_webhook_url" {
  description = "Full Jenkins webhook URL SonarQube should call after each analysis, e.g. http://jenkins.prasanna.fun:8080/sonarqube-webhook/. Leave empty string to skip webhook registration."
  type        = string
  default     = ""
}
