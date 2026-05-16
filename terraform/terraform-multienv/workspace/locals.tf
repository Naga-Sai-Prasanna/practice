locals {
  
  ami_id = "ami-0220d79f3f480ecf5" #initially as per cls we have to give ----ami_id = data.aws.ami_joindevops.id---- but here i won't created any ami so i am giving the ami directly.
  environment = terraform.workspace
}