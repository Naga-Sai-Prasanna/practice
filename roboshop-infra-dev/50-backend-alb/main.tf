#backend_alb


resource "aws_lb" "backend_alb" {
  name               = "${var.project}-${var.environment}"  #roboshop-dev
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend.alb_sg.id]
  subnets            = local.private_subnet.ids

# keeping it has false, just to delete using terraform while practice
  enable_deletion_protection = false


  tags = merge(
     {
     Name = "${var.project}-${var.environment}-backend-alb"
},
  local.common_tags
    
  ) 
}

# lb listner

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend_alb_.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "fixed-response"
   
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTP Backend ALB</h1>"
      status_code = "200"
    }
  }
 }


 #r53


resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"
 #load balancer details.
  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
