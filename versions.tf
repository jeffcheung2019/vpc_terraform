terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.73"
    }
  }
}

provider "aws" {
  region = "us-west-1"

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}