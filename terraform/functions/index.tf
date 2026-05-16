# roboshop.prasanna.fun. (frontend)--pub ip
  #here we use index function to get the public ip of the specific instance 

  
#   resource "aws_route53_record" "www" {
#     count = 10
#     zone_id = var.zone_id
#     # intercolation
#     name = "${var.instances[count.index]}.${var.domain_name}"
#     type = "A"
#     ttl = 1
#     records = [aws_instance.example[index(var.instances)].public_ip]
#     }