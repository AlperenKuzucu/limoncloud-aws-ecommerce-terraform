
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.77.0"
    }
  }

  # backend "s3" {
  #   bucket         = "<<project>>-tfstate-<<environment>>"
  #   key            = "infrastructure/terraform.tfstate"
  #   region         = "eu-central-1"
  #   profile        = "terraform-lab"
  # }
}

provider "aws" {
  region     = "eu-central-1"
  profile        = "terraform-lab"

  default_tags {
    tags = {
      Environment = "Test"
      Region = "eu-central-1"
      Terraform = "true"
    }
  }
}


module "main" {
  source = "../main"

  project = "Tf-Deneme"
  env     = "Test"
  region  = "eu-central-1"
}