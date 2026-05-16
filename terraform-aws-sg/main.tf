resource "aws_security_group" "main" {
    name = "${var.project}-${var.environment}-${var.sg_name}"
    description = "allow tls inbound traffic for ${var.project} in ${var.environment} for component ${var.sg_name}"
    vpc_id =  var.vpc_id

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-${var.sg_name}"
        },
        var.sg_tags
    )
}

