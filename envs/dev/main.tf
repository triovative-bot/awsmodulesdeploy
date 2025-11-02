module "vpc" {
  source = "../../modules/vpc"
  name   = var.name
  cidr   = var.vpc_cidr
  azs    = var.azs
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}

