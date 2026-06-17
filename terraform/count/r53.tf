resource "aws_route53_record" "www" {
    count = 10
    zone_id = var.zone_id
    # intercolation
    name = "${var.instances[count.index]}.${var.domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.example[count.index].private_ip]
    }


  # index function:
  resource "aws_route53_record" "www" {
    count = 10
    zone_id = var.zone_id
    # intercolation
    name = "${var.instances[count.index]}.${var.domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.example[index(var.instances, "frontend")].public_ip]
    }