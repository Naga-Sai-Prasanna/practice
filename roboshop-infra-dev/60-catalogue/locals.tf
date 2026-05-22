locals {
   ami_id = data.aws_ami.joindevops.id
  
   common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    private_subnet_id = split(",", data.aws.private_subnet_ids.value)[0]

}