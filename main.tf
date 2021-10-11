terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.62.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-kourt"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    terraform = true
    stage = var.stage
  }
}
