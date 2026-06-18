module "component" {
    for_each = var.components
    source = "git::https://github.com/Naga-Sai-Prasanna/practice.git//terraform-roboshop-component"
    component = each.key
    rule_priority = each.value.rule_priority
}
