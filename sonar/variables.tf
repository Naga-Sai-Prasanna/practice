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

variable "jenkins_ip" {
  description = "Public IP of the Jenkins agent, in CIDR form, e.g. 32.199.194.255/32. Needed so Jenkins can reach SonarQube on port 9000."
  type        = string
}

variable "jenkins_webhook_url" {
  description = "Full Jenkins webhook URL SonarQube should call after each analysis, e.g. http://jenkins.prasanna.fun:8080/sonarqube-webhook/. Leave empty string to skip webhook registration."
  type        = string
  default     = ""
}
