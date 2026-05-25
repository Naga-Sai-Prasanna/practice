# listner rule

resource "aws_ssm_parameter" "sg_id" {
 
  name  = "/${var.project}/${var.environment}/backend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listner.http.arn
}