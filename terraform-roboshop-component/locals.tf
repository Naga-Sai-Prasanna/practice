locals {
   ami_id = data.aws_ami.joindevops.id
  
   common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    sg_id = data.aws_ssm_parameter.sg_id.value
    private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
    health_check_path = var.components == "frontend" ? "/" : "/health"
    port_number = var.components == "frontend" ? 80 : 8080
    backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
    frontend_alb_listener_arn = data.aws_ssm_parameter.frontend_alb_listener_arn
    alb_listener_arn = var.components == "frontend" ? local.frontend_alb_listener_arn : local.backend_alb_listener_arn
    host_header =  var.components == "frontend" ? "${var.components}-${var.environment}.${var.domain_name}" : "${var.components}.backend-alb-${var.environment}.${var.domain_name}"
    vpc_id = data.ssm.parameter.vpc_id.value

}    