# resource "aws_route53_record" "www" {
    
#     zone_id = var.zone_id
#     # intercolation
#     name = "roboshop.${var.domain_name}". #mongodb.prasanna.fun
#     type = "A"
#     ttl = 1
#     records = [lookup(aws_instance.example,"frontend")]
#     allow_overwrite = true
#     }