module "component" {
    for_each = var.components
    source = "git::https://github.com/Naga-Sai-Prasanna/practice.git//terraform-roboshop-component"
    rule_priority = each.value.rule_priority
}

