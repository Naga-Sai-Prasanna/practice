resource "aws_instance" "catalogue" {
    ami  = local.ami_id
    instance_type = "t3.micro"
    subnet_id = local.private_subnet_id
    vpc_security_group_ids = [local.catalogue_sg_id]
      
    tags = merge(
        {
            Name = "${var.project}-${var.environment}-catalogue"
        },
        local.common_tags

    )
}

# connecting to mongodb instance through remote-exec

resource "terraform_data"  "bootstrap" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip

  }


} 

# stopping instance for ami

# action "aws_ec2_instance_state" "catalogue" {
#   instance_id = aws_instance.catalogue.id
#   state = "stopped"
# }

