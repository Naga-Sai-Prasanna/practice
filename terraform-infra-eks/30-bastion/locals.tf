locals {
   ami_id = data.aws_ami.joindevops.id
   # it is strinlist and we are taking string from it.
   # we will get 1a from pub subnet
   common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    # before we joined the public subnets.now we have to convert list to string
   public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
   bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
}