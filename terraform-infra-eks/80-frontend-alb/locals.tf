locals {
   ami_id = data.aws_ami.joindevops.id
  
   common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
    frontend_alb_certificate_arn = data.aws_ssm_parameter.frontend_alb_certificate_arn.value
}