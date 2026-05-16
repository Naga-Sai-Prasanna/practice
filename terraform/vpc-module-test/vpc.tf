module "vpc" {
    source = "git::https://github.com/Naga-Sai-Prasanna/terraform-aws-vpc.git"
    project = "roboshop"
    environment = "dev"



}

