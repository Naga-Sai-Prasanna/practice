# connection from internet to bastion

resource "aws_security_group_rule" "bastion_internet" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] or we can dynamically add our ip address
    #for this data.tf file add the query
    cidr_blocks = [local.my_ip]
    # which sg you are creating this rule
    security_group_id = local.bastion_sg_id
}

# connection from bastion to mongodb

resource "aws_security_group_rule" "mongodb_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # which sg you are creating this rule
    source_security_group_id = local.bastion_sg_id
    security_group_id = local.mongodb_sg_id
}



# connection from bastion to redis

resource "aws_security_group_rule" "redis_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # which sg you are creating this rule
    source_security_group_id = local.bastion_sg_id
    security_group_id = local.redis_sg_id
}







# connection from bastion to mysql

resource "aws_security_group_rule" "mysql_bastion" {
    type = "ingress"
    from_port = 3306 # in rds mysql allow bastion on port 3306 not 22
    to_port = 3306
    protocol = "tcp"
    # which sg you are creating this rule
    source_security_group_id = local.bastion_sg_id
    security_group_id = local.mysql_sg_id
}


# connection from eksnode to mysql

resource "aws_security_group_rule" "mysql_eks_node" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  # where traffic is coming from
  source_security_group_id = local.eks_node_sg_id
  security_group_id        = local.mysql_sg_id
}



# connection from bastion to rabbitmq

resource "aws_security_group_rule" "rabbitmq_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # which sg you are creating this rule
    source_security_group_id = local.bastion_sg_id
    security_group_id = local.rabbitmq_sg_id
}






# 






 

resource "aws_security_group_rule" "ingress_alb_public" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # which sg you are creating this rule
    security_group_id = local.ingress_alb_sg_id
}

# openvpn from public 443

resource "aws_security_group_rule" "openvpn_public_443" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

# oprnvpn from public 943

resource "aws_security_group_rule" "openvpn_public_943" {
  type      = "ingress"
  from_port = 943
  to_port   = 943
  protocol  = "tcp"
  # where traffic is coming from
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}


#eks_control_plane
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}



resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1" #all traffic
  # where traffic is coming from
  source_security_group_id = local.eks_control_plane_sg_id
  security_group_id        = local.eks_node_sg_id
}


resource "aws_security_group_rule" "eks_node_vpc_cidr" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1" #all traffic
  # where traffic is coming from
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id  = local.eks_node_sg_id
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # all traffic
  source_security_group_id = local.eks_node_sg_id
  security_group_id = local.eks_control_plane_sg_id
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

/* resource "aws_security_group_rule" "jenkins_agent_jenkins" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  source_security_group_id = local.jenkins_sg_id
  security_group_id = local.jenkins_agent_sg_id
} */

resource "aws_security_group_rule" "jenkins_agent_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.jenkins_agent_sg_id
}


#sonar
resource "aws_security_group_rule" "sonar_web" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.sonar_sg_id
}

resource "aws_security_group_rule" "sonar_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.sonar_sg_id
}