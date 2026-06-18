module "component" {
    for_each = var.components
    source = "git::https://github.com/Naga-Sai-Prasanna/terraform-roboshop-component.git"
    component = each.key
    rule_priority = each.value.rule_priority
}

