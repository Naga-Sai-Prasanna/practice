resource "aws_route53_record" "jenkins" {
  count = var.jenkins ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.jenkins[0].public_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "jenkins_agent" {
  count = var.jenkins ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins-agent.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.jenkins_agent[0].private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "sonarqube" {
  count = var.sonar ? 1 : 0
  zone_id = var.zone_id
  name    = "sonar.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.sonarqube[0].public_ip]
  allow_overwrite = true
}


## As Part of CICD ####
resource "aws_security_group_rule" "jenkins_public" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.jenkins_sg_id
}

resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.jenkins_sg_id
}

resource "aws_security_group_rule" "jenkins_agent_jenkins" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  source_security_group_id = local.jenkins_sg_id
  security_group_id = local.jenkins_agent_sg_id
} 

resource "aws_security_group_rule" "jenkins_agent_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.jenkins_agent_sg_id
}

# resource "aws_security_group_rule" "sonar_web" {
#   type              = "ingress"
#   from_port         = 9000
#   to_port           = 9000
#   protocol          = "tcp" # all traffic
#   # VPC CIDR
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = local.sonar_sg_id
# }

# resource "aws_security_group_rule" "sonar_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp" # all traffic
#   # VPC CIDR
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = local.sonar_sg_id
# }