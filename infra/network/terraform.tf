terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "kjaehyeok21/terraform-state"
    key = "network/terraform.tfstate"
  }
}