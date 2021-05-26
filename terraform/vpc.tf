###########################################
# VPC + SUBNET + IGW + ROUTE TABLE
###########################################

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = var.region
}

locals {
  cluster_name = "help-queue-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name                 = "help-queue-tf-vpc"
  cidr                 = "22.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["22.0.1.0/24", "22.0.2.0/24", "22.0.3.0/24"]
  public_subnets       = ["22.0.4.0/24", "22.0.5.0/24", "22.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
