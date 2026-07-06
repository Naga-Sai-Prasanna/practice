terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
  }

  # storing state file in remote state

  backend "s3" {
    bucket       = "remote-state-prasannak" #replace with your bucket anme
    key          = "roboshop-dev-ecr"  # to what it shoulb be saved can't we reuse the same name
    region       = "us-east-1"
    use_lockfile = true # to avoid multiple people working on same state file at the same time
  }
}

provider "aws" {
  region = "us-east-1"
}