module "vpc" {
    source =  "git::https://github.com/Naga-Sai-Prasanna/practice.git?ref=main"
    project = var.project
    environment = var.environment
    is_peering_required = true



}