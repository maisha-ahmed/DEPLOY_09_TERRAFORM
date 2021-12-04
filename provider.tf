terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "terraform"
  default_tags {
    tags = {
      Deployment = "DEPLOYMENT_09_TERRAFORM"
      Team       = "Kura Labs"
    }
  }
}
