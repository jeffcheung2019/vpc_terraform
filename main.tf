locals {
  vpc_name = "bastion-vpc"
  ec2_name   = "bastion-host"
  region = "us-west-1"
}

module "bastion_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = "10.1.0.0/16"

  azs             = ["${local.region}b", "${local.region}c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  enable_ipv6 = false
  enable_nat_gateway = false

  public_subnet_tags = {
    Name = "public"
  }

  private_subnet_tags = {
    Name = "private"
  }

  vpc_tags = {
    Name = "bastion-vpc"
  }
  
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${module.bastion_vpc.vpc_id}"

  ingress {
    description      = "SSH ingress"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${module.bastion_vpc.vpc_cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   name = local.ec2_name

#   ami                    = "ami-00f7e5c52c0f43726"
#   instance_type          = "t3.nano"
#   key_name               = "bastion_user_key"
#   monitoring             = false
#   vpc_security_group_ids = ["sg-12345678"]
#   subnet_id              = "subnet-eddcdzz4"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }