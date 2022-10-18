locals {
  name   = "bastion-host"
  region = "us-west-1"

  tags = {
    Name = local.name
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.1.0.0/16"

  azs             = ["${local.region}b", "${local.region}c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  enable_ipv6 = false
  enable_nat_gateway = false

  public_subnet_tags = {
    Name = "public"
  }

  tags = local.tags

  vpc_tags = {
    Name = "bastion-vpc"
  }
}