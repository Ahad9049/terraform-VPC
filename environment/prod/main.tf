module "vpc" {
  source               = "../../module/vpc"
  aws_region           = var.aws_region
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project              = var.project
  owner                = var.owner
  environment          = var.environment
}